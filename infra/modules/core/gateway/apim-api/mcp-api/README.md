<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                               | Version  |
| ------------------------------------------------------------------ | -------- |
| <a name="requirement_azapi"></a> [azapi](#requirement_azapi)       | ~>2.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~>4.60.0 |

## Providers

| Name                                                         | Version  |
| ------------------------------------------------------------ | -------- |
| <a name="provider_azapi"></a> [azapi](#provider_azapi)       | ~>2.0.0  |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~>4.60.0 |

## Resources

| Name                                                                                                                                                       | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azapi_resource.mcp_api](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource)                                               | resource |
| [azurerm_api_management_api_diagnostic.mcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_policy.mcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy)         | resource |
| [azurerm_api_management_backend.mcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_backend)               | resource |

## Inputs

| Name                                                                                                      | Description                                                             | Type     | Default | Required |
| --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_api_management_id"></a> [api_management_id](#input_api_management_id)                      | API Management resource ID (for parent_id)                              | `string` | n/a     |   yes    |
| <a name="input_api_management_logger_id"></a> [api_management_logger_id](#input_api_management_logger_id) | The resource ID of the Application Insights logger for APIM diagnostics | `string` | n/a     |   yes    |
| <a name="input_api_name"></a> [api_name](#input_api_name)                                                 | API name                                                                | `string` | n/a     |   yes    |
| <a name="input_apim_service_name"></a> [apim_service_name](#input_apim_service_name)                      | API Management service name                                             | `string` | n/a     |   yes    |
| <a name="input_mcp_api_uri_template"></a> [mcp_api_uri_template](#input_mcp_api_uri_template)             | URI template for MCP API                                                | `string` | n/a     |   yes    |
| <a name="input_mcp_url"></a> [mcp_url](#input_mcp_url)                                                    | Endpoint URL of mcp                                                     | `string` | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                | Resource group name                                                     | `string` | n/a     |   yes    |
| <a name="input_sampling_percentage"></a> [sampling_percentage](#input_sampling_percentage)                | Percentage of requests to log to Application Insights (0.0 to 100.0)    | `number` | `100`   |    no    |

## Outputs

| Name                                                                                | Description |
| ----------------------------------------------------------------------------------- | ----------- |
| <a name="output_api_id"></a> [api_id](#output_api_id)                               | n/a         |
| <a name="output_api_name"></a> [api_name](#output_api_name)                         | n/a         |
| <a name="output_api_uri_template"></a> [api_uri_template](#output_api_uri_template) | n/a         |

<!-- END_TF_DOCS -->
