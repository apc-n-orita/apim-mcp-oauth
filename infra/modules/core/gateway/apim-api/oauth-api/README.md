<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                               | Version  |
| ------------------------------------------------------------------ | -------- |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~>4.60.0 |
| <a name="requirement_random"></a> [random](#requirement_random)    | ~>3.7.0  |

## Providers

| Name                                                         | Version  |
| ------------------------------------------------------------ | -------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~>4.60.0 |

## Resources

| Name                                                                                                                                                                                                       | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_api_management_api.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api)                                                                     | resource |
| [azurerm_api_management_api_diagnostic.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic)                                               | resource |
| [azurerm_api_management_api_operation.oauth_protected_resource_get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                          | resource |
| [azurerm_api_management_api_operation.oauth_protected_resource_options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                      | resource |
| [azurerm_api_management_api_operation_policy.oauth_protected_resource_get_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)     | resource |
| [azurerm_api_management_api_operation_policy.oauth_protected_resource_options_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy)                                                       | resource |
| [azurerm_api_management_named_value.apim_gateway_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                                          | resource |

## Inputs

| Name                                                                                                      | Description                                                              | Type     | Default | Required |
| --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ | -------- | ------- | :------: |
| <a name="input_api_management_logger_id"></a> [api_management_logger_id](#input_api_management_logger_id) | The resource ID of the Application Insights logger for APIM diagnostics. | `string` | n/a     |   yes    |
| <a name="input_apim_gateway_url"></a> [apim_gateway_url](#input_apim_gateway_url)                         | The gateway URL of the API Management service                            | `string` | n/a     |   yes    |
| <a name="input_apim_service_name"></a> [apim_service_name](#input_apim_service_name)                      | The name of the API Management service                                   | `string` | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                | n/a                                                                      | `any`    | n/a     |   yes    |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id)                                              | The Entra ID (Azure AD) tenant ID                                        | `string` | n/a     |   yes    |
| <a name="input_sampling_percentage"></a> [sampling_percentage](#input_sampling_percentage)                | Percentage of requests to log to Application Insights (0.0 to 100.0)     | `number` | `100`   |    no    |

## Outputs

| Name                                                                    | Description |
| ----------------------------------------------------------------------- | ----------- |
| <a name="output_api_name"></a> [api_name](#output_api_name)             | n/a         |
| <a name="output_oauth_api_id"></a> [oauth_api_id](#output_oauth_api_id) | n/a         |

<!-- END_TF_DOCS -->
