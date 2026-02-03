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
| [azapi_resource.logicapp](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_update_resource.logicapp_auth](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource) | resource |
| [azurerm_role_assignment.uai_storage_account_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_blob_data_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_queue_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_table_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.logicapp_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_share.logicapp_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_principal_id"></a> [apim\_principal\_id](#input\_apim\_principal\_id) | The Principal ID of the APIM Managed Identity (for authsettings) | `string` | n/a | yes |
| <a name="input_application_insights_connection_string"></a> [application\_insights\_connection\_string](#input\_application\_insights\_connection\_string) | The Application Insights connection string | `string` | n/a | yes |
| <a name="input_azuread_application_entra_app_client_id"></a> [azuread\_application\_entra\_app\_client\_id](#input\_azuread\_application\_entra\_app\_client\_id) | The Client ID of the Entra ID app (for authsettings) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Logic App Standard | `string` | n/a | yes |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | The resource ID of the resource group | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The resource group name | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name of the App Service Plan | `string` | n/a | yes |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | The storage account access key (for Azure Files) | `string` | n/a | yes |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | The resource ID of the storage account | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The storage account name | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure AD Tenant ID | `string` | n/a | yes |
| <a name="input_user_assigned_identity_client_id"></a> [user\_assigned\_identity\_client\_id](#input\_user\_assigned\_identity\_client\_id) | The Client ID of the User-Assigned Managed Identity | `string` | n/a | yes |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | The resource ID of the User-Assigned Managed Identity | `string` | n/a | yes |
| <a name="input_user_assigned_identity_principal_id"></a> [user\_assigned\_identity\_principal\_id](#input\_user\_assigned\_identity\_principal\_id) | The Principal ID of the User-Assigned Managed Identity | `string` | n/a | yes |
| <a name="input_extension_bundle_version"></a> [extension\_bundle\_version](#input\_extension\_bundle\_version) | The Logic Apps Extension Bundle version range | `string` | `"[1.*, 2.0.0)"` | no |
| <a name="input_functions_extension_version"></a> [functions\_extension\_version](#input\_functions\_extension\_version) | The Azure Functions extension version | `string` | `"~4"` | no |
| <a name="input_node_version"></a> [node\_version](#input\_node\_version) | The Node.js runtime version | `string` | `"~18"` | no |
| <a name="input_powershell_version"></a> [powershell\_version](#input\_powershell\_version) | The PowerShell runtime version | `string` | `"7.4"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logicapp_default_hostname"></a> [logicapp\_default\_hostname](#output\_logicapp\_default\_hostname) | The default hostname of the Logic App |
| <a name="output_logicapp_id"></a> [logicapp\_id](#output\_logicapp\_id) | The resource ID of the Logic App Standard |
| <a name="output_logicapp_name"></a> [logicapp\_name](#output\_logicapp\_name) | The name of the Logic App Standard |
| <a name="output_logicapp_system_principal_id"></a> [logicapp\_system\_principal\_id](#output\_logicapp\_system\_principal\_id) | The System-Assigned Managed Identity Principal ID of the Logic App |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | The resource ID of the App Service Plan |
<!-- END_TF_DOCS -->
