<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.58.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>2.0.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.58.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.mcp_api](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_api_management_api_diagnostic.mcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_policy.mcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_backend.mcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_backend) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_id"></a> [api\_management\_id](#input\_api\_management\_id) | API Management resource ID (for parent\_id) | `string` | n/a | yes |
| <a name="input_api_management_logger_id"></a> [api\_management\_logger\_id](#input\_api\_management\_logger\_id) | The resource ID of the Application Insights logger for APIM diagnostics | `string` | n/a | yes |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | API name | `string` | n/a | yes |
| <a name="input_apim_service_name"></a> [apim\_service\_name](#input\_apim\_service\_name) | API Management service name | `string` | n/a | yes |
| <a name="input_mcp_api_uri_template"></a> [mcp\_api\_uri\_template](#input\_mcp\_api\_uri\_template) | URI template for MCP API | `string` | n/a | yes |
| <a name="input_mcp_url"></a> [mcp\_url](#input\_mcp\_url) | Endpoint URL of mcp | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage) | Percentage of requests to log to Application Insights (0.0 to 100.0) | `number` | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | n/a |
| <a name="output_api_name"></a> [api\_name](#output\_api\_name) | n/a |
| <a name="output_api_uri_template"></a> [api\_uri\_template](#output\_api\_uri\_template) | n/a |
<!-- END_TF_DOCS -->