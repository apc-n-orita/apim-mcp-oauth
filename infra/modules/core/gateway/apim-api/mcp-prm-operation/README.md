<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.60.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.60.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api_operation.get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation_policy.get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_gateway_url"></a> [apim\_gateway\_url](#input\_apim\_gateway\_url) | Gateway URL of the API Management instance (used as the "resource" field in the metadata response) | `string` | n/a | yes |
| <a name="input_apim_service_name"></a> [apim\_service\_name](#input\_apim\_service\_name) | The name of the API Management service | `string` | n/a | yes |
| <a name="input_mcp_endpoint_path"></a> [mcp\_endpoint\_path](#input\_mcp\_endpoint\_path) | Full path suffix of the actual MCP client-facing endpoint, i.e. everything after the APIM gateway URL and before any query string (e.g. "la-mcp-.../api/mcpservers/projects/mcp"). No leading/trailing slash. | `string` | n/a | yes |
| <a name="input_mcp_server_id"></a> [mcp\_server\_id](#input\_mcp\_server\_id) | Short identifier for the MCP server (e.g. "funcmcp", "lamcp"), used to build the operation\_id/display\_name. Must contain only alphanumeric characters, underscores and dashes. | `string` | n/a | yes |
| <a name="input_prm_api_name"></a> [prm\_api\_name](#input\_prm\_api\_name) | Name of the shared PRM discovery API (oauth-api module's api\_name output) that this operation attaches to | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name of the existing API Management instance | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | OAuth scope advertised in scopes\_supported for this MCP server (e.g. api://<app-id>/user\_impersonation) | `string` | n/a | yes |
| <a name="input_mcp_endpoint_query"></a> [mcp\_endpoint\_query](#input\_mcp\_endpoint\_query) | Query string suffix (including leading "?") to append to the "resource" field, matching the actual MCP client URL when it requires a query parameter. Empty if the endpoint takes no query string. | `string` | `""` | no |
<!-- END_TF_DOCS -->