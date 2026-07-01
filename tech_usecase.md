# Technical Details and Use Cases

## Technical Details

### Backend MCP Authorization Architecture

#### Overview

Backend MCP (Azure Functions and Logic Apps) enforces authorization at two independent layers, so that even if one layer is misconfigured, the other still blocks unauthorized access.

| Layer | Mechanism | Enforced by |
|---|---|---|
| Transport | Easy Auth (Entra ID token validation) | Azure App Service platform |
| Application | `Mcp.Invoke` App Role check | Function App code / Logic App workflow |

#### Who Can Access the Backend Directly

Only the following two identities hold the `Mcp.Invoke` App Role and can reach the backend:

| Identity | How `Mcp.Invoke` is granted | Typical use |
|---|---|---|
| APIM Managed Identity | Direct App Role assignment to the MSI | All production traffic via APIM |
| Ops Entra ID group members | App Role assignment to the ops security group | Troubleshooting, integration testing |

Normal end-users go through APIM. APIM validates the user token (including per-tool role claims), then replaces it with the APIM MSI token before forwarding to the backend. The backend never sees the user's original token.

#### Function App: Authorization Implementation

**Easy Auth** (`webhookAuthorizationLevel: "Anonymous"` in `host.json`)

```json
"extensions": {
  "mcp": {
    "system": {
      "webhookAuthorizationLevel": "Anonymous"
    }
  }
}
```

Setting `webhookAuthorizationLevel` to `"Anonymous"` disables the MCP extension system key. Easy Auth (configured separately on the App Service) becomes the sole transport-layer guard — it validates the Entra ID bearer token and injects `x-ms-client-principal` (Base64-encoded claims JSON) into request headers.

**Application-level `Mcp.Invoke` check** (`function_app.py`)

The function code decodes `x-ms-client-principal` and checks for `{"typ": "roles", "val": "Mcp.Invoke"}` in the claims array. If the claim is absent, the tool returns `"Forbidden: Mcp.Invoke role required"` without raising an exception (which would generate unnecessary Application Insights stack traces).

```python
def _check_mcp_invoke_role(principal_header: str) -> bool:
    # Decodes x-ms-client-principal injected by Easy Auth.
    # Logs only the failure reason (header_missing / role_not_found / decode_error),
    # never the token content itself.
    ...

def _run_mcp_tool(tool_name: str, message: str, ctx: func.MCPToolContext) -> str:
    if not _check_mcp_invoke_role(_get_mcp_headers(ctx).get("x-ms-client-principal", "")):
        _logger.warning("Access denied.", extra={"tool": tool_name})
        return "Forbidden: Mcp.Invoke role required"
    return _echo_tool(tool_name, message)
```

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

In APIM, by configuring the following policy, you can return information about the OAuth authorization server (Entra ID) in JSON format. This metadata includes the resource URL, authorization server endpoint, supported authentication methods, and scopes.

In addition, an `OPTIONS /.well-known/oauth-protected-resource` operation policy returns CORS preflight headers so browser-based clients can retrieve this metadata safely.

VS Code uses this metadata to access the authorization server (e.g., `https://login.microsoftonline.com/{{EntraIDTenantId}}/v2.0`) and obtain an access token with the `api://{{oauth-app-id}}/user_impersonation` scope.

```xml
<policies>
    <inbound>
        <!-- Return OAuth metadata as JSON -->
        <return-response>
            <set-status code="200" reason="OK" />
            <set-header name="Content-Type" exists-action="override">
                <value>application/json; charset=utf-8</value>
            </set-header>
            <set-header name="access-control-allow-origin" exists-action="override">
                <value>*</value>
            </set-header>
            <set-body>@{
                return new JObject(
                    new JProperty("resource", "{{APIMGatewayURL}}/"),
                    new JProperty("authorization_servers", new JArray("https://login.microsoftonline.com/{{EntraIDTenantId}}/v2.0")),
                    new JProperty("bearer_methods_supported", new JArray("header")),
                    new JProperty("scopes_supported", new JArray("api://{{oauth-app-id}}/user_impersonation"))
                ).ToString();
            }</set-body>
        </return-response>
        <base />
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

#### Backend Protection with Managed Identity

`authentication-managed-identity` overwrites the Authorization header with APIM's Managed Identity token before forwarding to the backend MCP (Logic Apps/Functions). The backend enforces authorization via Easy Auth + `Mcp.Invoke` App Role check, so only callers with that role (APIM MSI or ops group members) can reach it — see [Backend MCP Authorization Architecture](#backend-mcp-authorization-architecture) for details.

```xml
<!--
    - Policies are applied in the order they appear.
    - Place <base/> inside a section to inherit policies from the outer scope.
    - Comments inside policies are not preserved.
-->
<!-- Add policies as children of <inbound>, <outbound>, <backend>, and <on-error> -->
<policies>
    <!-- Throttle, authorize, validate, cache, or transform incoming requests -->
    <inbound>
        <base />
        <validate-azure-ad-token tenant-id="{{EntraIDTenantId}}" header-name="Authorization" output-token-variable-name="jwt" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid">
            <audiences>
                <audience>api://{{oauth-app-id}}/</audience>
            </audiences>
        </validate-azure-ad-token>
        <!-- Parse JSON body -->
        <set-variable name="mcpBody" value="@(
            context.Request.Body.As<JObject>(preserveContent: true)
        )" />
        <set-variable name="mcpMethod" value="@{
            var body = (JObject)context.Variables["mcpBody"];
            return (string)body?["method"] ?? string.Empty;
        }" />
        <choose>
            <!-- Authenticate only tool calls -->
            <when condition="@((context.Variables.GetValueOrDefault<string>("mcpMethod") ?? "").Equals("tools/call", StringComparison.OrdinalIgnoreCase))">
                <set-variable name="mcpToolName" value="@{
                    var body = context.Request.Body.As<JObject>(preserveContent: true);
                    return (string)body["params"]?["name"] ?? "";
                }" />
                <set-variable name="isAuthorized" value="@{
                    var jwt = (Jwt)context.Variables["jwt"];
                    if (jwt == null || !jwt.Claims.ContainsKey("roles")) { return false; }
                    var toolName = (string)context.Variables["mcpToolName"];
                    if (string.IsNullOrEmpty(toolName)) { return false; }

                    return jwt.Claims["roles"].Any(role =>
                        role.Equals(toolName, StringComparison.OrdinalIgnoreCase) ||
                        (role.EndsWith("*") && toolName.StartsWith(role.Substring(0, role.Length - 1), StringComparison.OrdinalIgnoreCase))
                    );
                }" />
                <choose>
                    <when condition="@((bool)context.Variables["isAuthorized"])">
                        <!-- Authorized, pass through -->
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="403" reason="Forbidden" />
                            <set-body>@("{\"error\":\"Role missing or invalid\"}")</set-body>
                        </return-response>
                    </otherwise>
                </choose>
            </when>
        </choose>
        <!-- Acquire token using Managed Identity -->
        <authentication-managed-identity resource="{{oauth-app-id}}" output-token-variable-name="msi-access-token" ignore-error="false" />
        <!-- Override Authorization header with MSI token -->
        <set-header name="Authorization" exists-action="override">
            <value>@("Bearer " + (string)context.Variables["msi-access-token"])</value>
        </set-header>
        <!-- Remove subscription key header -->
        <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
    </inbound>
    <!-- Control how requests are forwarded to backend services -->
    <backend>
        <base />
    </backend>
    <!-- Customize outbound responses -->
    <outbound>
        <base />
    </outbound>
    <!-- Handle exceptions and customize error responses -->
    <on-error>
        <base />
    </on-error>
</policies>
```

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
> - **copilot-instructions.md /CLAUDE.md / AGENTS.md**: Standing instructions injected into every agent session. Explicitly define allowed operations, forbidden actions (e.g., "never delete branches in production repos"), and required escalation paths for high-risk operations.
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
