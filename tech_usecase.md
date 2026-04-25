# Technical Details and Use Cases

## Technical Details

### APIM Policy Explanation

#### Overview of OAuth Metadata Policy

When VS Code (GitHub Copilot extension) accesses the MCP endpoint (`/mcp`), APIM returns a 401 response because authentication is required. At this point, the client automatically sends a GET request to APIM's `/.well-known/oauth-protected-resource` endpoint to retrieve OAuth metadata.

In APIM, by configuring the following policy, you can return information about the OAuth authorization server (Entra ID) in JSON format. This metadata includes the resource URL, authorization server endpoint, supported authentication methods, and scopes.

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

#### Flexible Permission Management Using Wildcards

During MCP tool execution (`tools/call`), the policy checks whether the token's `roles` claim permits the requested tool—supporting both exact match and wildcard (`*`) prefix match. For example, a role `Mcp_Arithmetic_*` automatically authorizes `Mcp_Arithmetic_Add`, `Mcp_Arithmetic_Sub`, and other tools with the same prefix. If authorized, the request proceeds; otherwise, a 403 error is returned.

#### Backend Protection with Managed Identity

`authentication-managed-identity` overwrites the token with APIM's Managed Identity token and sends it to the backend MCP (Logic Apps/Functions). By configuring Easy Auth to allow only APIM's Managed Identity, access other than through APIM is blocked.

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

                    var userRoles = jwt.Claims["roles"]; // Assumed to be string[]
                    var toolName = (string)context.Variables["mcpToolName"];

                    // Wildcard matching logic
                    foreach (var role in userRoles) {
                        // Pattern A: Exact match (e.g., hello_project1)
                        if (role.Equals(toolName, StringComparison.OrdinalIgnoreCase)) { return true; }

                        // Pattern B: Wildcard match
                        // Allows cases where role is "Mcp_Arithmetic_*" and tool name is "Mcp_Arithmetic_Add"
                        // Check prefix match excluding the trailing '*' from the role name
                        if (role.EndsWith("*")) {
                            var prefix = role.Substring(0, role.Length - 1);
                            // Case-insensitive check if tool name starts with the role's prefix
                            if (toolName.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)) { return true; }
                        }
                    }
                    return false;
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

> For centralized authentication and authorization management of official MCPs like GitHub MCP, I personally believe that [ID-JUG (Identity Assertion Authorization Grant)](https://github.com/oauth-wg/oauth-identity-assertion-authz-grant/blob/main/draft-ietf-oauth-identity-assertion-authz-grant.md) proposed by the OAuth Working Group is promising.

### MCP Tool Permission Isolation per AI Foundry Project

Enables individual control of MCP tool access across multiple AI Foundry projects. By assigning only necessary App Roles to each project's Managed Identity, permission isolation between projects can be achieved.

### Individual Permission Configuration for Entra ID Agent Identity Instances

Enables individual control of MCP tool access for each **Agent Identity** (agent identity instance). By configuring minimum necessary permissions for each agent, a secure agent environment can be established.

## Enhanced Security

- By combining with Entra ID Conditional Access, multi-layered security policies can be applied based on device state, network, risk level, etc.
  - For Agent Identities, applying policies at the blueprint level enables bulk protection of all agents of the same type.

---

[Conclusion](./README.md#conclusion)
