# Technical Details and Use Cases

## Technical Details

### Backend MCP Authorization Architecture

#### Overview

Backend MCP (Logic Apps) enforces authorization at two independent layers, so that even if one layer is misconfigured, the other still blocks unauthorized access.

| Layer | Mechanism | Enforced by |
|---|---|---|
| Transport | Easy Auth (Entra ID token validation) | Azure App Service platform |
| Application | `Mcp.Invoke` App Role check | Logic App workflow |

#### Who Can Access the Backend Directly

Only the following two identities hold the `Mcp.Invoke` App Role and can reach the backend:

| Identity | How `Mcp.Invoke` is granted | Typical use |
|---|---|---|
| APIM Managed Identity | Direct App Role assignment to the MSI | All production traffic via APIM |
| Ops Entra ID group members | App Role assignment to the ops security group | Troubleshooting, integration testing |

Normal end-users go through APIM. APIM validates the user token (including per-tool role claims), then replaces it with the APIM MSI token before forwarding to the backend. The backend never sees the user's original token.

#### Logic App: Authorization Implementation

**OAuth2-only mode** (`host.json`)

```json
"extensions": {
  "workflow": {
    "McpServerEndpoints": {
      "enable": true,
      "authentication": {
        "type": "oauth2"
      }
    }
  }
}
```

Setting `authentication.type` to `"oauth2"` disables the MCP API key. Only OAuth2 bearer tokens are accepted.

**Application-level `Mcp.Invoke` check** (workflow actions)

Each Logic App workflow decodes `x-ms-client-principal` injected by Easy Auth and filters the claims array for `Mcp.Invoke`:

```
Parse_Client_Principal → Filter_Mcp_Invoke_Role → Check_Mcp_Invoke_Role
```

If no matching claim is found, the workflow returns HTTP 403.

#### Access Token Flow: APIM as Token Broker

When a request arrives at APIM with a user token:

1. `validate-azure-ad-token` validates signature, issuer, audience, and expiry.
2. For `tools/call`, the policy checks per-tool role claims (`roles` array) — exact match or wildcard prefix (e.g., `common_*`).
3. `authentication-managed-identity` acquires the APIM MSI token (which carries `Mcp.Invoke`).
4. The `Authorization` header is replaced with the MSI token before forwarding to the backend.

The backend only ever sees the MSI token — never the end-user's token.

#### Preventing Token Leakage in Logs

Tokens are kept out of telemetry (Application Insights) and run history by design, on both backends.

**Logic App**

- Every workflow enables **Secure Inputs / Secure Outputs** (`runtimeConfiguration.secureData`) so that token material never appears in run history:
  - `Request` trigger — inputs and outputs secured: incoming headers (`Authorization`, `x-ms-client-principal`) are hidden.
  - `Parse_Client_Principal` — inputs secured: the decoded claims JSON is hidden.
  - `Filter_Mcp_Invoke_Role` — inputs and outputs secured: the claims array being filtered is hidden.

#### PIM (Privileged Identity Management) for JIT Access in Production

**Current hands-on setup**: The user who runs `azd up` is assigned directly as an **active member** of the ops group. Active membership is permanent until explicitly removed.

**Production recommendation**: Use **PIM for Groups** to grant **eligible membership** instead of active membership. Eligible members must explicitly activate their group membership (JIT access) for a limited time window before they can access the backend directly.

| | Current hands-on | Production recommendation |
|---|---|---|
| Membership type | Active (permanent) | Eligible (JIT) |
| Activation required | No | Yes (via Entra portal / My Access) |
| Maximum activation duration | N/A | Configurable (e.g., 8 hours) |
| Approval workflow | N/A | Optional (can require approver) |
| MFA on activation | N/A | Enforceable |
| Audit trail | Group membership log | PIM activation log (with justification) |

**How PIM for Groups works** ([MS Docs: PIM for Groups](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/concept-pim-for-groups)):

1. Bring the ops security group under PIM management in the Entra admin center.
2. Assign ops team members as **eligible** (not active) members of the group.
3. When a member needs direct backend access, they activate their membership via [My Access](https://myaccess.microsoft.com) or the Entra portal — the activation is reflected in new tokens within seconds.
4. After the activation window expires, the membership is deactivated automatically.

> **Note on token caching**: PIM activates/deactivates group membership in Entra ID within seconds. However, existing cached access tokens (e.g., from `az account get-access-token`) retain the old claims until they expire (up to 1 hour). Obtain a fresh token after activating PIM membership to immediately reflect the `Mcp.Invoke` role.

**License requirement**: PIM for Groups requires **Microsoft Entra ID P2** or **Microsoft Entra ID Governance** for each eligible user.

### APIM Policy Explanation

#### Overview of OAuth Metadata Policy

When VS Code (GitHub Copilot extension) accesses the MCP endpoint (`/mcp`), APIM returns a 401 response because authentication is required. At this point, the client automatically sends a GET request to APIM's `/.well-known/oauth-protected-resource` endpoint to retrieve OAuth metadata.

The shared `.well-known/oauth-protected-resource` API is just an empty path shell (see the `oauth-api` Terraform module). Each MCP backend attaches its own GET/OPTIONS operation underneath it via the `mcp-prm-operation` module, so the JSON returned — resource URL, authorization server endpoint, supported authentication methods, and scope — reflects that specific backend rather than a single fixed value shared by every MCP server.

An `OPTIONS /.well-known/oauth-protected-resource` operation policy (added by the same module) returns CORS preflight headers so browser-based clients can retrieve this metadata safely.

VS Code uses this metadata to access the authorization server (e.g., `https://login.microsoftonline.com/{{EntraIDTenantId}}/v2.0`) and obtain an access token with the scope this backend advertises (e.g., `api://<oauth-app-id>/user_impersonation` for the Logic App MCP backend).

```xml
<policies>
    <inbound>
        <base />
        <!-- Return the OAuth 2.0 Protected Resource Metadata (RFC 9728) in JSON format,
             scoped to this MCP server's own path/scope -->
        <return-response>
            <set-status code="200" reason="OK" />
            <set-header name="Content-Type" exists-action="override">
                <value>application/json; charset=utf-8</value>
            </set-header>
            <set-header name="access-control-allow-origin" exists-action="override">
                <value>*</value>
            </set-header>
            <set-header name="Cache-Control" exists-action="override">
                <value>public, max-age=3600</value>
            </set-header>
            <set-body>@{
                return new JObject(
                    new JProperty("resource", "${apim_gateway_url}/${mcp_endpoint_path}${mcp_endpoint_query}"),
                    new JProperty("authorization_servers", new JArray("https://login.microsoftonline.com/{{EntraIDTenantId}}/v2.0")),
                    new JProperty("bearer_methods_supported", new JArray("header")),
                    new JProperty("scopes_supported", new JArray("${scope}"))
                ).ToString();
            }</set-body>
        </return-response>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
```

`apim_gateway_url`, `mcp_endpoint_path`, `mcp_endpoint_query`, and `scope` are Terraform `templatefile()` variables substituted per backend at apply time — e.g. for the Logic App MCP backend, `mcp_endpoint_path` resolves to its API name plus `/api/mcpservers/projects/mcp`, and `scope` to `api://<oauth-app-id>/user_impersonation`. `{{EntraIDTenantId}}` remains an APIM named value (shared across all backends) rather than a Terraform variable. See [`mcp_prm_get_policy.xml`](infra/modules/core/gateway/apim-api/mcp-prm-operation/files/policy/mcp_prm_get_policy.xml) for the full policy.

#### Overview of OAuth Token Validation Policy

When VS Code obtains an access token and accesses the `/mcp` endpoint, APIM validates the access token.

The token validation policy uses `validate-azure-ad-token` to perform the following validations:

- **Retrieve Public Key**: Based on the `tenant-id`, automatically fetches the tenant's latest public key (JWKS) from Entra ID's metadata endpoint (openid-configuration).
- **Verify Signature**: Validates the signature in the token header from the client using the retrieved public key. This proves that the token payload (user information and permissions) has not been tampered with after being issued by Entra ID.
- **Check Expiration**: Verifies that the token is not expired by checking the `exp` claim.
- **Verify Issuer**: Confirms that the `iss` claim is the correct URL for the specified tenant.
- **Validate Audience**: Verifies that the token was issued for the correct resource (`api://{{oauth-app-id}}/`).

#### Flexible Role-Based Tool Authorization

Authorization is enforced only when the MCP method is `tools/call`. The policy extracts `params.name` as the requested tool name and rejects the request if the name is empty.

The requested tool is then compared with the access token's `roles` claim using the following rules:

- **Exact match**: e.g., role `hello_project1` permits `hello_project1`.
- **Wildcard prefix match**: e.g., role `common_*` permits tools whose names start with `common_`.

If no rule matches, APIM returns `403 Forbidden`.

#### Duplicate JSON Keys: A Potential Authorization Bypass

**Background.** Neither JSON (RFC 8259), JSON-RPC 2.0, nor the MCP specification defines how a parser must resolve duplicate keys in an object (e.g., two `method` properties, or `params` appearing twice). RFC 8259 only says names *should* be unique — behavior on violation is implementation-defined. This means each component in the request path (the gateway and the backend) is free to pick its own resolution order (first-wins, last-wins, or error), independently of the others.

**Why this matters here.** The authorization logic above reads `method` and `params.name` from the request body to decide whether to allow a `tools/call`. `authentication-managed-identity` then forwards the *original, unmodified* request body to the backend. If the body contains a duplicate key and the backend's JSON parser resolves it differently than APIM did, the method or tool name APIM authorized against can differ from the one the backend actually executes — the same class of inconsistency that HTTP request smuggling exploits between a front-end proxy and a back-end server, applied to JSON parsing instead of HTTP framing.

Example shape of the attack (illustrative, not verbatim):

```json
{"jsonrpc":"2.0","id":1,"method":"tools/list","method":"tools/call","params":{"name":"restricted_tool"}}
```

If APIM resolves `method` to `tools/list` (skipping the tool-authorization branch entirely) while the backend resolves it to `tools/call`, an unauthorized tool invocation could slip through without ever hitting the `403` branch.

**Verified behavior.** We tested this against the backend (Logic Apps Standard MCP; an earlier revision of this environment also deployed an Azure Functions MCP backend, since removed, which showed the same behavior), duplicating the key at three different levels — the top-level `method`, the entire `params` object, and just the `name` field inside a single `params` object — and reversing the order in each case. Result: **APIM (Newtonsoft.Json) and the backend consistently resolve duplicate keys last-wins** at every level tested. (Full request/response matrix omitted here; this reflects observed behavior of the specific library versions in this deployment, not a spec guarantee.)

Because this agreement is incidental — an artifact of the specific parser versions involved, not something the spec requires — it isn't safe to rely on indefinitely. A future dependency update or a language/runtime change on the backend could silently reintroduce the bypass.

**Mitigation: normalize before forwarding.** Rather than depend on the backend agreeing with APIM's interpretation, the policy re-serializes the already-parsed, already-authorized `JObject` and forwards *that* instead of the raw request bytes. This makes the forwarded body single-valued at the point it left APIM, so there is nothing left for the backend to resolve differently:

```xml
<!-- After the tools/call authorization choose block, before authentication-managed-identity -->
<set-body>@(((JObject)context.Variables["mcpBody"]).ToString())</set-body>
```

This closes the gap regardless of what parser or resolution order the backend uses, and regardless of whether the duplicate appears in `method`, `params`, or a nested field like `params.name`.

#### Backend Protection with Managed Identity

`authentication-managed-identity` overwrites the Authorization header with APIM's Managed Identity token before forwarding to the backend MCP (Logic Apps/Functions). The backend enforces authorization via Easy Auth + `Mcp.Invoke` App Role check, so only callers with that role (APIM MSI or ops group members) can reach it — see [Backend MCP Authorization Architecture](#backend-mcp-authorization-architecture) for details.

```xml
<!-- Acquire token using Managed Identity -->
<authentication-managed-identity resource="{{oauth-app-id}}" output-token-variable-name="msi-access-token" ignore-error="false" />
<!-- Override Authorization header with MSI token -->
<set-header name="Authorization" exists-action="override">
    <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
</set-header>
<!-- Remove subscription key header -->
<set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
```

See [`mcp_api_policy.xml`](infra/modules/core/gateway/mcp-product/files/policy/mcp_api_policy.xml) for the full policy.

### OAuth App (Entra ID App Registration and Role Configuration)

Register an MCP app in Entra ID (formerly Azure AD) and create app roles with the same names as the MCP tool names (e.g., `hello_project1`, `hello_project2`, `common_*`, `secret_*`).

- In this hands-on lab, these roles are assigned to the user who executed `azd up`.
- The app role's "Allowed member types" specifies both "Users/Groups" and "Applications," allowing roles to be assigned not only to users and groups but also to Managed Identities (e.g., AI Foundry projects or agent IDs).

## End-to-End Protection Use Cases with API Management × MCP × OAuth

### Centralized Authentication and Authorization for Custom MCPs

Enables centralized authentication and authorization management for enterprise-specific custom MCPs.

> **Note on Official MCPs (e.g., GitHub MCP, Azure MCP, Slack MCP)**
>
> For official MCPs, restricting access at the MCP tool level has limited effectiveness. In practice, AI agents — and the developers who operate them — frequently bypass MCP entirely by invoking the platform CLI directly (e.g., `gh` commands, raw REST/GraphQL API calls). Since the same underlying operation can be performed either through an MCP tool or a direct CLI call, controlling only the MCP path leaves a wide-open alternative route.
>
> More robust and comprehensive approaches are:
>
> #### 1. Platform-Side RBAC
>
> Restrict what the agent's credential can do at the platform level, regardless of how it was invoked (MCP, CLI, or direct API). Each platform — GitHub, Azure, Slack, and others — provides its own RBAC or other permission controls. Applying least-privilege settings there ensures the restriction holds no matter which execution path the agent takes.
>
> #### 2. Harness Engineering (Agent Skills)
>
> [Harness engineering](https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents) treats the agent's runtime environment — system prompts, skill definitions, and hooks — as a behavioral governance layer that controls _how_ the agent acts, independent of which tools are available. Key controls:
>
> - **copilot-instructions.md / CLAUDE.md / AGENTS.md**: Standing instructions injected into every agent session. Explicitly define allowed operations, forbidden actions (e.g., "never delete branches in production repos"), and required escalation paths for high-risk operations.
> - **Agent Skills (SKILL.md)**: Markdown files with YAML frontmatter that restrict auto-invocation (`disable-model-invocation: true`), scope allowed tools (`allowed-tools`), and activate on specific conditions. See the [Agent Skills open standard](https://agentskills.io).
> - **Hooks**: Deterministic shell commands that approve or deny tool calls based on input patterns. Unlike prompt-based instructions (which are probabilistic), hooks provide hard enforcement at the tool-call boundary.

### MCP Tool Permission Isolation per AI Foundry Project

Enables individual control of MCP tool access across multiple AI Foundry projects. By assigning only necessary App Roles to each project's Managed Identity, permission isolation between projects can be achieved.

### Individual Permission Configuration for Entra ID Agent Identity Instances

Enables individual control of MCP tool access for each **Agent Identity** (agent identity instance). By configuring minimum necessary permissions for each agent, a secure agent environment can be established.

## Enhanced Security

- By combining with Entra ID Conditional Access, multi-layered security policies can be applied based on device state, network, risk level, etc.
  - For Agent Identities, applying policies at the blueprint level enables bulk protection of all agents of the same type.

---

[Conclusion](./README.md#conclusion)
