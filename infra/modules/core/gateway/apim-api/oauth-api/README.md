<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.58.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.58.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_diagnostic.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_operation.oauth_protected_resource_get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_protected_resource_options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation_policy.oauth_protected_resource_get_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_protected_resource_options_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_named_value.apim_gateway_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_logger_id"></a> [api\_management\_logger\_id](#input\_api\_management\_logger\_id) | The resource ID of the Application Insights logger for APIM diagnostics. | `string` | n/a | yes |
| <a name="input_apim_gateway_url"></a> [apim\_gateway\_url](#input\_apim\_gateway\_url) | The gateway URL of the API Management service | `string` | n/a | yes |
| <a name="input_apim_service_name"></a> [apim\_service\_name](#input\_apim\_service\_name) | The name of the API Management service | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Entra ID (Azure AD) tenant ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_name"></a> [api\_name](#output\_api\_name) | n/a |
| <a name="output_oauth_api_id"></a> [oauth\_api\_id](#output\_oauth\_api\_id) | n/a |
<!-- END_TF_DOCS -->
