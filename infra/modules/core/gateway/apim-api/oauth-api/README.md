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
| [azurerm_api_management_api.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_diagnostic.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_logger_id"></a> [api\_management\_logger\_id](#input\_api\_management\_logger\_id) | The resource ID of the Application Insights logger for APIM diagnostics. | `string` | n/a | yes |
| <a name="input_apim_service_name"></a> [apim\_service\_name](#input\_apim\_service\_name) | The name of the API Management service | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name of the existing API Management instance | `string` | n/a | yes |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Name of the API on APIM | `string` | `"oauth"` | no |
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | Path of the API on APIM (no leading/trailing slash). Fixed to the RFC 9728 well-known path so MCP-server-specific operations (see the mcp-prm-operation module) can be added underneath it. | `string` | `".well-known/oauth-protected-resource"` | no |
| <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage) | Percentage of requests to log to Application Insights (0.0 to 100.0) | `number` | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_name"></a> [api\_name](#output\_api\_name) | Name of the oauth API on APIM |
| <a name="output_oauth_api_id"></a> [oauth\_api\_id](#output\_oauth\_api\_id) | Resource ID of the oauth API |
<!-- END_TF_DOCS -->
