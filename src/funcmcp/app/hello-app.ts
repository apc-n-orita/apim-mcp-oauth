import { App } from "@modelcontextprotocol/ext-apps";

const el = (id: string) => document.getElementById(id)!;

function applyTheme(theme: string | undefined): void {
  document.documentElement.dataset.theme = theme || "dark";
}

function parseToolResultText(
  content: Array<{ type: string; text?: string }> | undefined
): string | null {
  if (!content || content.length === 0) return null;
  const textBlock = content.find((c) => c.type === "text" && c.text);
  return textBlock?.text ?? null;
}

const app = new App({ name: "Hello Widget", version: "1.0.0" });

app.ontoolinput = (params) => {
  const args = params.arguments as Record<string, string> | undefined;
  const message = args?.message ?? "";
  el("input-message").textContent = message || "(empty)";
  el("response-message").textContent = "—";
  el("status").textContent = "Processing…";
  app.sendLog({ level: "info", data: `Tool input received: ${message}` });
};

app.ontoolresult = (params) => {
  const text = parseToolResultText(
    params.content as Array<{ type: string; text?: string }>
  );
  if (text !== null) {
    el("response-message").textContent = text;
    el("status").textContent = "Echo received";
    el("footer").textContent = new Date().toLocaleTimeString();
  } else {
    el("response-message").textContent = "Error parsing response";
    el("status").textContent = "Error";
  }
};

app.onhostcontextchanged = (ctx) => {
  if (ctx.theme) applyTheme(ctx.theme);
};

(async () => {
  await app.connect();
  applyTheme(app.getHostContext()?.theme);
  el("status").textContent = "Connected";
})();
