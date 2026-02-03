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
| <a name="input_apim_principal_id"></a> [apim\_principal\_id](#input\_apim\_principal\_id) | APIMのManaged IdentityのPrincipal ID (authsettings用) | `string` | n/a | yes |
| <a name="input_application_insights_connection_string"></a> [application\_insights\_connection\_string](#input\_application\_insights\_connection\_string) | Application Insights 接続文字列 | `string` | n/a | yes |
| <a name="input_azuread_application_entra_app_client_id"></a> [azuread\_application\_entra\_app\_client\_id](#input\_azuread\_application\_entra\_app\_client\_id) | Entra IDアプリのClient ID (authsettings用) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure リージョン | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Logic App Standard の名前 | `string` | n/a | yes |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | リソースグループのリソースID | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | リソースグループ名 | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | App Service PlanのSKU名 | `string` | n/a | yes |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | ストレージアカウントのアクセスキー (Azure Files 用) | `string` | n/a | yes |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | ストレージアカウントの Resource ID | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | ストレージアカウント名 | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure AD Tenant ID | `string` | n/a | yes |
| <a name="input_user_assigned_identity_client_id"></a> [user\_assigned\_identity\_client\_id](#input\_user\_assigned\_identity\_client\_id) | User-Assigned Managed Identity の Client ID | `string` | n/a | yes |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | User-Assigned Managed Identity のリソースID | `string` | n/a | yes |
| <a name="input_user_assigned_identity_principal_id"></a> [user\_assigned\_identity\_principal\_id](#input\_user\_assigned\_identity\_principal\_id) | User-Assigned Managed Identity の Principal ID | `string` | n/a | yes |
| <a name="input_extension_bundle_version"></a> [extension\_bundle\_version](#input\_extension\_bundle\_version) | Logic Apps Extension Bundle のバージョン範囲 | `string` | `"[1.*, 2.0.0)"` | no |
| <a name="input_functions_extension_version"></a> [functions\_extension\_version](#input\_functions\_extension\_version) | Azure Functions 拡張バージョン | `string` | `"~4"` | no |
| <a name="input_node_version"></a> [node\_version](#input\_node\_version) | Node.js ランタイムバージョン | `string` | `"~18"` | no |
| <a name="input_powershell_version"></a> [powershell\_version](#input\_powershell\_version) | PowerShell ランタイムバージョン | `string` | `"7.4"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | リソースに付与するタグ | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logicapp_default_hostname"></a> [logicapp\_default\_hostname](#output\_logicapp\_default\_hostname) | Logic App のデフォルトホスト名 |
| <a name="output_logicapp_id"></a> [logicapp\_id](#output\_logicapp\_id) | Logic App Standard のリソースID |
| <a name="output_logicapp_name"></a> [logicapp\_name](#output\_logicapp\_name) | Logic App Standard の名前 |
| <a name="output_logicapp_system_principal_id"></a> [logicapp\_system\_principal\_id](#output\_logicapp\_system\_principal\_id) | Logic App の System-Assigned Managed Identity Principal ID |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | App Service Plan のリソースID |
<!-- END_TF_DOCS -->