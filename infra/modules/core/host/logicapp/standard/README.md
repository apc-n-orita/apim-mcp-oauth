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

| Name                                                                                                                                                          | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azapi_resource.logicapp](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource)                                                 | resource |
| [azapi_update_resource.logicapp_auth](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource)                              | resource |
| [azurerm_role_assignment.uai_storage_account_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)    | resource |
| [azurerm_role_assignment.uai_storage_blob_data_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)        | resource |
| [azurerm_role_assignment.uai_storage_queue_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_table_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.logicapp_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan)                            | resource |
| [azurerm_storage_share.logicapp_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share)                         | resource |

## Inputs

| Name                                                                                                                                                   | Description                                                      | Type          | Default          | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------- | ------------- | ---------------- | :------: |
| <a name="input_apim_principal_id"></a> [apim_principal_id](#input_apim_principal_id)                                                                   | The Principal ID of the APIM Managed Identity (for authsettings) | `string`      | n/a              |   yes    |
| <a name="input_application_insights_connection_string"></a> [application_insights_connection_string](#input_application_insights_connection_string)    | The Application Insights connection string                       | `string`      | n/a              |   yes    |
| <a name="input_azuread_application_entra_app_client_id"></a> [azuread_application_entra_app_client_id](#input_azuread_application_entra_app_client_id) | The Client ID of the Entra ID app (for authsettings)             | `string`      | n/a              |   yes    |
| <a name="input_location"></a> [location](#input_location)                                                                                              | The Azure region                                                 | `string`      | n/a              |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                                                          | The name of the Logic App Standard                               | `string`      | n/a              |   yes    |
| <a name="input_rg_id"></a> [rg_id](#input_rg_id)                                                                                                       | The resource ID of the resource group                            | `string`      | n/a              |   yes    |
| <a name="input_rg_name"></a> [rg_name](#input_rg_name)                                                                                                 | The resource group name                                          | `string`      | n/a              |   yes    |
| <a name="input_sku_name"></a> [sku_name](#input_sku_name)                                                                                              | The SKU name of the App Service Plan                             | `string`      | n/a              |   yes    |
| <a name="input_storage_account_access_key"></a> [storage_account_access_key](#input_storage_account_access_key)                                        | The storage account access key (for Azure Files)                 | `string`      | n/a              |   yes    |
| <a name="input_storage_account_id"></a> [storage_account_id](#input_storage_account_id)                                                                | The resource ID of the storage account                           | `string`      | n/a              |   yes    |
| <a name="input_storage_account_name"></a> [storage_account_name](#input_storage_account_name)                                                          | The storage account name                                         | `string`      | n/a              |   yes    |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id)                                                                                           | Azure AD Tenant ID                                               | `string`      | n/a              |   yes    |
| <a name="input_user_assigned_identity_client_id"></a> [user_assigned_identity_client_id](#input_user_assigned_identity_client_id)                      | The Client ID of the User-Assigned Managed Identity              | `string`      | n/a              |   yes    |
| <a name="input_user_assigned_identity_id"></a> [user_assigned_identity_id](#input_user_assigned_identity_id)                                           | The resource ID of the User-Assigned Managed Identity            | `string`      | n/a              |   yes    |
| <a name="input_user_assigned_identity_principal_id"></a> [user_assigned_identity_principal_id](#input_user_assigned_identity_principal_id)             | The Principal ID of the User-Assigned Managed Identity           | `string`      | n/a              |   yes    |
| <a name="input_extension_bundle_version"></a> [extension_bundle_version](#input_extension_bundle_version)                                              | The Logic Apps Extension Bundle version range                    | `string`      | `"[1.*, 2.0.0)"` |    no    |
| <a name="input_functions_extension_version"></a> [functions_extension_version](#input_functions_extension_version)                                     | The Azure Functions extension version                            | `string`      | `"~4"`           |    no    |
| <a name="input_node_version"></a> [node_version](#input_node_version)                                                                                  | The Node.js runtime version                                      | `string`      | `"~18"`          |    no    |
| <a name="input_powershell_version"></a> [powershell_version](#input_powershell_version)                                                                | The PowerShell runtime version                                   | `string`      | `"7.4"`          |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                                          | Tags to apply to resources                                       | `map(string)` | `{}`             |    no    |

## Outputs

| Name                                                                                                                    | Description                                                        |
| ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| <a name="output_logicapp_default_hostname"></a> [logicapp_default_hostname](#output_logicapp_default_hostname)          | The default hostname of the Logic App                              |
| <a name="output_logicapp_id"></a> [logicapp_id](#output_logicapp_id)                                                    | The resource ID of the Logic App Standard                          |
| <a name="output_logicapp_name"></a> [logicapp_name](#output_logicapp_name)                                              | The name of the Logic App Standard                                 |
| <a name="output_logicapp_system_principal_id"></a> [logicapp_system_principal_id](#output_logicapp_system_principal_id) | The System-Assigned Managed Identity Principal ID of the Logic App |
| <a name="output_service_plan_id"></a> [service_plan_id](#output_service_plan_id)                                        | The resource ID of the App Service Plan                            |

<!-- END_TF_DOCS -->
