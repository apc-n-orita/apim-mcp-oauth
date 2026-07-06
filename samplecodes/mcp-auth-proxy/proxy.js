/**
 * MCP Auth Proxy
 * -----------------------------------------------------------------------
 * 目的:
 *   Claude Code の .mcp.json にある "headersHelper" (シェルコマンドを実行して
 *   Authorization ヘッダーを生成する機能) は、Claude Code の起動時や MCP 接続の
 *   再確立時にのみ実行され、リクエスト毎に自動更新されるわけではない(README.md
 *   の「Access token expiry and reconnection」参照)。Azure AD (Entra ID) の
 *   access token は通常 1時間程度で失効するため、長時間のセッションでは
 *   headersHelper でも結局トークン切れが起こり得る。
 *
 *   さらに Codex CLI / Gemini CLI などのMCP サーバー設定は、そもそも
 *   headersHelper のようなコマンド実行機能自体を持たず、起動時に環境変数や
 *   設定値を1回読むだけになる(2026-07時点)。このプロキシを間に挟むことで、
 *   クライアント側の設定を一切変えずに「リクエスト毎に有効なトークンで中継する」
 *   という、headersHelper よりも一段確実な挙動を後付けできる。
 *
 * 仕組み:
 *   MCPクライアント → (認証ヘッダーなしで) このプロキシ(127.0.0.1:PORT)
 *                   → プロキシが az account get-access-token でトークンを取得/キャッシュ
 *                   → Authorization ヘッダーを付与して APIM (TARGET) へ転送
 *
 * 使い方:
 *   1. 依存パッケージをインストール
 *        cd samplecodes/mcp-auth-proxy
 *        npm install
 *
 *   2. 環境に合わせて TARGET / SCOPE / PORT を編集(または環境変数で上書き)
 *
 *   3. プロキシを起動(常駐させる。tmux/nohup/systemd --user 等で永続化推奨)
 *        node proxy.js
 *      または
 *        nohup node proxy.js > proxy.log 2>&1 &
 *
 *   4. az login 済みであることを確認(このプロキシは az CLI のログイン状態を利用する)
 *        az login
 *
 *   5. 各MCPクライアントの設定で、実際のAPIMエンドポイントの代わりに
 *      このプロキシのURLを向ける(パスはそのまま TARGET 配下に転送される)。
 *
 * --- Claude Code (.mcp.json) の場合 ---
 *   もともと headersHelper で動的トークン取得ができるため、このプロキシは
 *   必須ではない。ただし複数クライアントで設定を共通化したい場合は同様に
 *   プロキシのURLを指定してもよい。
 *   {
 *     "mcpServers": {
 *       "<mcp-server-name>": {
 *         "type": "http",
 *         "url": "http://127.0.0.1:8787/<mcp-backend-path>"
 *       }
 *     }
 *   }
 *
 * --- Codex CLI (~/.codex/config.toml) の場合 ---
 *   [mcp_servers.<mcp-server-name>]
 *   url = "http://127.0.0.1:8787/<mcp-backend-path>"
 *   # bearer_token_env_var / http_headers は不要(プロキシ側で付与するため)
 *
 * --- Gemini CLI (~/.gemini/settings.json) の場合 ---
 *   {
 *     "mcpServers": {
 *       "<mcp-server-name>": {
 *         "httpUrl": "http://127.0.0.1:8787/<mcp-backend-path>"
 *       }
 *     }
 *   }
 *
 * 注意:
 *   - プロキシは 127.0.0.1 のみにバインドしており、外部からはアクセスできない。
 *   - ログにはトークンの有効期限のみ出力し、トークン文字列自体は出力しない。
 */

const http = require("http");
const httpProxy = require("http-proxy");
const { execFileSync } = require("child_process");

// 環境変数で上書き可能。TARGET / SCOPE は各自の環境に合わせて必ず設定すること。
// OAUTH_APP_ID は `azd env get-value OAUTH_APP_ID` で取得できる(README.md 参照)。
const TARGET =
  process.env.MCP_PROXY_TARGET || "https://<APIM_NAME>.azure-api.net";
const SCOPE =
  process.env.MCP_PROXY_SCOPE || "api://<OAUTH_APP_ID>/.default";
const PORT = Number(process.env.MCP_PROXY_PORT || 8787);

let cachedToken = null;
let expiresAt = 0;

// 有効なトークンを返す。期限切れが近い場合のみ az CLI で再取得する。
// - execFileSync(配列引数)を使い、SCOPE の値がシェルに解釈されるのを防ぐ。
// - expires_on (UTC の POSIX タイムスタンプ) を使う。expiresOn はタイムゾーンを
//   含まないローカル時刻文字列で、DST切り替え時に誤判定する既知の問題があるため
//   使わない (https://github.com/Azure/azure-cli/issues/19700)。
function getToken() {
  const now = Date.now();
  console.log("getToken called at", new Date(now).toISOString());

  if (cachedToken && now < expiresAt - 60_000) {
    console.log(
      "cache hit, reusing token (expires at",
      new Date(expiresAt).toISOString() + ")",
    );
    return cachedToken;
  }

  let out;
  try {
    out = execFileSync("az", [
      "account",
      "get-access-token",
      "--scope",
      SCOPE,
      "--query",
      "{t:accessToken,e:expires_on}",
      "-o",
      "json",
    ]).toString();
  } catch (err) {
    throw new Error(
      `failed to acquire access token via az CLI: ${err.message}`,
    );
  }

  const { t, e } = JSON.parse(out);

  cachedToken = t;
  expiresAt = e * 1000; // expires_on は秒単位のUTC POSIXタイムスタンプ
  console.log("token refreshed, expires at", new Date(expiresAt).toISOString());

  return cachedToken;
}

const proxy = httpProxy.createProxyServer({
  target: TARGET,
  changeOrigin: true,
});

// res の状態に応じて502を返す。ヘッダー送信済みなら書き直さず接続を閉じるだけにする。
function send502(res, message) {
  if (res.headersSent) {
    res.end();
    return;
  }
  res.writeHead(502, { "Content-Type": "text/plain" });
  res.end("proxy error: " + message);
}

// 転送直前に、常に最新のトークンでAuthorizationヘッダーを上書きする。
// node-http-proxy は "proxyReq" イベントリスナーの例外を捕捉しない
// (投げると "error" イベントには変換されずプロセスがクラッシュする)ため、
// az CLI 呼び出し失敗(未ログイン等)はここで自前でcatchし、502を返す。
proxy.on("proxyReq", (proxyReq, req, res) => {
  let token;
  try {
    token = getToken();
  } catch (err) {
    console.error("failed to set Authorization header:", err.message);
    proxyReq.destroy();
    send502(res, err.message);
    return;
  }
  proxyReq.setHeader("Authorization", `Bearer ${token}`);
});

proxy.on("error", (err, req, res) => {
  console.error("proxy error:", err.message);
  send502(res, err.message);
});

http
  .createServer((req, res) => proxy.web(req, res))
  .listen(PORT, "127.0.0.1", () => {
    console.log(
      `MCP auth proxy listening on http://127.0.0.1:${PORT} -> ${TARGET}`,
    );
  });
