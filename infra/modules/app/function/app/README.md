<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                               | Version  |
| ------------------------------------------------------------------ | -------- |
| <a name="requirement_azapi"></a> [azapi](#requirement_azapi)       | ~>2.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~>4.60.0 |
| <a name="requirement_random"></a> [random](#requirement_random)    | ~>3.7.0  |

## Providers

| Name                                                         | Version  |
| ------------------------------------------------------------ | -------- |
| <a name="provider_azapi"></a> [azapi](#provider_azapi)       | ~>2.0.0  |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~>4.60.0 |
| <a name="provider_random"></a> [random](#provider_random)    | ~>3.7.0  |
| <a name="provider_time"></a> [time](#provider_time)          | n/a      |

## Resources

| Name                                                                                                                                                   | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [azapi_resource.function](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource)                                          | resource |
| [azapi_update_resource.func_auth](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource)                           | resource |
| [azurerm_storage_container.function_blob_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_string.container_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                | resource |
| [time_sleep.wait_function](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep)                                         | resource |

## Inputs

| Name                                                                                                                                                   | Description                                                   | Type                                                                     | Default               | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------------------------------------ | --------------------- | :------: |
| <a name="input_apim_principal_id"></a> [apim_principal_id](#input_apim_principal_id)                                                                   | Principal ID of APIM Managed Identity (for allowedPrincipals) | `string`                                                                 | n/a                   |   yes    |
| <a name="input_app_service_plan_id"></a> [app_service_plan_id](#input_app_service_plan_id)                                                             | App Service Plan resource ID                                  | `string`                                                                 | n/a                   |   yes    |
| <a name="input_application_insights_connection_string"></a> [application_insights_connection_string](#input_application_insights_connection_string)    | Application Insights connection string                        | `string`                                                                 | n/a                   |   yes    |
| <a name="input_azuread_application_entra_app_client_id"></a> [azuread_application_entra_app_client_id](#input_azuread_application_entra_app_client_id) | Client ID of the Entra ID application for AAD auth            | `string`                                                                 | n/a                   |   yes    |
| <a name="input_function_storage_id"></a> [function_storage_id](#input_function_storage_id)                                                             | Storage account ID for Function App                           | `string`                                                                 | n/a                   |   yes    |
| <a name="input_identity_client_id"></a> [identity_client_id](#input_identity_client_id)                                                                | Client ID of the user-assigned identity                       | `string`                                                                 | n/a                   |   yes    |
| <a name="input_identity_id"></a> [identity_id](#input_identity_id)                                                                                     | Resource ID of the user-assigned identity                     | `string`                                                                 | n/a                   |   yes    |
| <a name="input_location"></a> [location](#input_location)                                                                                              | Azure region                                                  | `string`                                                                 | n/a                   |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                                                          | Function App name                                             | `string`                                                                 | n/a                   |   yes    |
| <a name="input_primary_blob_endpoint"></a> [primary_blob_endpoint](#input_primary_blob_endpoint)                                                       | Primary Blob Endpoint of the storage account                  | `string`                                                                 | n/a                   |   yes    |
| <a name="input_rg_id"></a> [rg_id](#input_rg_id)                                                                                                       | Resource group ID                                             | `string`                                                                 | n/a                   |   yes    |
| <a name="input_storage_account_name"></a> [storage_account_name](#input_storage_account_name)                                                          | Storage account name for Function App                         | `string`                                                                 | n/a                   |   yes    |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id)                                                                                           | Azure AD Tenant ID                                            | `string`                                                                 | n/a                   |   yes    |
| <a name="input_app_settings"></a> [app_settings](#input_app_settings)                                                                                  | Additional app settings as a list of name/value pairs         | <pre>list(object({<br/> name = string<br/> value = string<br/> }))</pre> | `[]`                  |    no    |
| <a name="input_instance_memory_mb"></a> [instance_memory_mb](#input_instance_memory_mb)                                                                | Memory (MB) per instance for scaleAndConcurrency              | `number`                                                                 | `2048`                |    no    |
| <a name="input_kind"></a> [kind](#input_kind)                                                                                                          | Kind of the Function App (e.g. functionapp,linux)             | `string`                                                                 | `"functionapp,linux"` |    no    |
| <a name="input_maximum_instance_count"></a> [maximum_instance_count](#input_maximum_instance_count)                                                    | Maximum instance count for scaleAndConcurrency                | `number`                                                                 | `100`                 |    no    |
| <a name="input_runtime_name"></a> [runtime_name](#input_runtime_name)                                                                                  | Runtime name (e.g. python)                                    | `string`                                                                 | `"python"`            |    no    |
| <a name="input_runtime_version"></a> [runtime_version](#input_runtime_version)                                                                         | Runtime version (e.g. 3.10)                                   | `string`                                                                 | `"3.11"`              |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                                          | Tags to apply                                                 | `map(string)`                                                            | `{}`                  |    no    |

## Outputs

| Name                                                                                               | Description |
| -------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_identity_principal_id"></a> [identity_principal_id](#output_identity_principal_id) | n/a         |
| <a name="output_name"></a> [name](#output_name)                                                    | n/a         |
| <a name="output_uri"></a> [uri](#output_uri)                                                       | n/a         |

<!-- END_TF_DOCS -->
