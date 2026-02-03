<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>3.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>2.0.0 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~>3.5.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.42.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.logicapp](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_update_resource.logicapp_auth](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource) | resource |
| [azuread_application.entra_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_identifier_uri.entra_app_uri](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_identifier_uri) | resource |
| [azuread_application_permission_scope.user_impersonation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_permission_scope) | resource |
| [azuread_service_principal.entra_app_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_api_management_named_value.logic_app_oauth_app_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_application_insights.logicapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_role_assignment.logicapp_search_index_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_file_data_privileged_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_monitoring_metrics_publisher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_account_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_blob_data_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_queue_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai_storage_table_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.logicapp_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_share.logicapp_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_share_directory.Tartaria_folder](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share_directory) | resource |
| [azurerm_storage_share_file.Tartaria_workflow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share_file) | resource |
| [azurerm_user_assigned_identity.logicapp_uai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [local_file.Tartaria_json_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_uuid.user_impersonation_scope_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [time_sleep.wait_logicapp](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_api_management_subscription.apim_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management_subscription) | data source |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_storage_share.existing_file_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_share) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_name"></a> [apim\_name](#input\_apim\_name) | API Management 名 | `string` | n/a | yes |
| <a name="input_apim_rg_name"></a> [apim\_rg\_name](#input\_apim\_rg\_name) | API Management が存在するリソースグループ名 | `string` | n/a | yes |
| <a name="input_apim_subscription_id"></a> [apim\_subscription\_id](#input\_apim\_subscription\_id) | API Management Subscription ID (サブスクリプションキーを取得するため) | `string` | n/a | yes |
| <a name="input_azureuser_object_id"></a> [azureuser\_object\_id](#input\_azureuser\_object\_id) | Azure AD ユーザーの Object ID (App Registration の Owner として設定) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure リージョン | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Log Analytics Workspace 名 | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Logic App Standard の名前 | `string` | n/a | yes |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | リソースグループのリソースID | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | リソースグループ名 | `string` | n/a | yes |
| <a name="input_search_index_name"></a> [search\_index\_name](#input\_search\_index\_name) | Azure AI Search インデックス名 | `string` | n/a | yes |
| <a name="input_search_service_id"></a> [search\_service\_id](#input\_search\_service\_id) | Azure AI Search サービスの Resource ID | `string` | n/a | yes |
| <a name="input_search_service_name"></a> [search\_service\_name](#input\_search\_service\_name) | Azure AI Search サービス名 | `string` | n/a | yes |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | ストレージアカウントのアクセスキー (Azure Files 用) | `string` | n/a | yes |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | ストレージアカウントの Resource ID | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | ストレージアカウント名 | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure AD Tenant ID | `string` | n/a | yes |
| <a name="input_extension_bundle_version"></a> [extension\_bundle\_version](#input\_extension\_bundle\_version) | Logic Apps Extension Bundle のバージョン範囲 | `string` | `"[1.*, 2.0.0)"` | no |
| <a name="input_functions_extension_version"></a> [functions\_extension\_version](#input\_functions\_extension\_version) | Azure Functions 拡張バージョン | `string` | `"~4"` | no |
| <a name="input_node_version"></a> [node\_version](#input\_node\_version) | Node.js ランタイムバージョン | `string` | `"~18"` | no |
| <a name="input_powershell_version"></a> [powershell\_version](#input\_powershell\_version) | PowerShell ランタイムバージョン | `string` | `"7.4"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | リソースに付与するタグ | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_insights_connection_string"></a> [application\_insights\_connection\_string](#output\_application\_insights\_connection\_string) | Application Insights 接続文字列 |
| <a name="output_application_insights_id"></a> [application\_insights\_id](#output\_application\_insights\_id) | Application Insights のリソースID |
| <a name="output_entra_app_client_id"></a> [entra\_app\_client\_id](#output\_entra\_app\_client\_id) | Entra ID Application (Easy Auth) の Client ID (Application ID) |
| <a name="output_entra_app_id"></a> [entra\_app\_id](#output\_entra\_app\_id) | Entra ID Application (Easy Auth) のリソースID |
| <a name="output_entra_app_identifier_uri"></a> [entra\_app\_identifier\_uri](#output\_entra\_app\_identifier\_uri) | Entra ID Application の Identifier URI |
| <a name="output_entra_app_object_id"></a> [entra\_app\_object\_id](#output\_entra\_app\_object\_id) | Entra ID Application (Easy Auth) の Object ID |
| <a name="output_logicapp_default_hostname"></a> [logicapp\_default\_hostname](#output\_logicapp\_default\_hostname) | Logic App のデフォルトホスト名 |
| <a name="output_logicapp_id"></a> [logicapp\_id](#output\_logicapp\_id) | Logic App Standard のリソースID |
| <a name="output_logicapp_name"></a> [logicapp\_name](#output\_logicapp\_name) | Logic App Standard の名前 |
| <a name="output_logicapp_system_principal_id"></a> [logicapp\_system\_principal\_id](#output\_logicapp\_system\_principal\_id) | Logic App の System-Assigned Managed Identity Principal ID |
| <a name="output_logicapp_user_assigned_client_id"></a> [logicapp\_user\_assigned\_client\_id](#output\_logicapp\_user\_assigned\_client\_id) | User-Assigned Managed Identity の Client ID |
| <a name="output_logicapp_user_assigned_identity_id"></a> [logicapp\_user\_assigned\_identity\_id](#output\_logicapp\_user\_assigned\_identity\_id) | User-Assigned Managed Identity のリソースID |
| <a name="output_logicapp_user_assigned_principal_id"></a> [logicapp\_user\_assigned\_principal\_id](#output\_logicapp\_user\_assigned\_principal\_id) | User-Assigned Managed Identity の Principal ID |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | App Service Plan のリソースID |
| <a name="output_storage_share_id"></a> [storage\_share\_id](#output\_storage\_share\_id) | ストレージ共有ID |
| <a name="output_storage_share_name"></a> [storage\_share\_name](#output\_storage\_share\_name) | ストレージ共有名 |
<!-- END_TF_DOCS -->