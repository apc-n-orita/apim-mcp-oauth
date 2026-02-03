<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.42.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>2.0.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.42.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~>3.7.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.function](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource_action.functionapp_host_keys](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_storage_container.function_blob_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_string.container_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.wait_function](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | App Service Plan resource ID | `string` | n/a | yes |
| <a name="input_function_storage_id"></a> [function\_storage\_id](#input\_function\_storage\_id) | Storage account ID for Function App | `string` | n/a | yes |
| <a name="input_identity_id"></a> [identity\_id](#input\_identity\_id) | Resource ID of the user-assigned identity | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Function App name | `string` | n/a | yes |
| <a name="input_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#input\_primary\_blob\_endpoint) | Primary Blob Endpoint of the storage account | `string` | n/a | yes |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | Resource group ID | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account name for Function App | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Additional app settings as a list of name/value pairs | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_application_insights_connection_string"></a> [application\_insights\_connection\_string](#input\_application\_insights\_connection\_string) | Application Insights connection string | `string` | `""` | no |
| <a name="input_identity_client_id"></a> [identity\_client\_id](#input\_identity\_client\_id) | Client ID of the user-assigned identity | `string` | `""` | no |
| <a name="input_instance_memory_mb"></a> [instance\_memory\_mb](#input\_instance\_memory\_mb) | Memory (MB) per instance for scaleAndConcurrency | `number` | `2048` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | Kind of the Function App (e.g. functionapp,linux) | `string` | `"functionapp,linux"` | no |
| <a name="input_maximum_instance_count"></a> [maximum\_instance\_count](#input\_maximum\_instance\_count) | Maximum instance count for scaleAndConcurrency | `number` | `100` | no |
| <a name="input_runtime_name"></a> [runtime\_name](#input\_runtime\_name) | Runtime name (e.g. python) | `string` | `"python"` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Runtime version (e.g. 3.10) | `string` | `"3.11"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | n/a |
| <a name="output_masterkey"></a> [masterkey](#output\_masterkey) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_uri"></a> [uri](#output\_uri) | n/a |
<!-- END_TF_DOCS -->