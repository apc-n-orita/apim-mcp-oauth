<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7, < 2.0.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>3.5.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~>1.2.24 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.58.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.5.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.32 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.58.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apim"></a> [apim](#module\_apim) | ./modules/core/gateway/apim | n/a |
| <a name="module_fC-appserviceplan"></a> [fC-appserviceplan](#module\_fC-appserviceplan) | ./modules/core/host/appserviceplan | n/a |
| <a name="module_func_mcp"></a> [func\_mcp](#module\_func\_mcp) | ./modules/app/function/app | n/a |
| <a name="module_func_mcp_api"></a> [func\_mcp\_api](#module\_func\_mcp\_api) | ./modules/core/gateway/apim-api/mcp-api | n/a |
| <a name="module_func_mcp_role"></a> [func\_mcp\_role](#module\_func\_mcp\_role) | ./modules/app/function/role | n/a |
| <a name="module_func_mcp_storage"></a> [func\_mcp\_storage](#module\_func\_mcp\_storage) | ./modules/core/storage | n/a |
| <a name="module_la_mcp"></a> [la\_mcp](#module\_la\_mcp) | ./modules/core/host/logicapp/standard | n/a |
| <a name="module_la_mcp_api"></a> [la\_mcp\_api](#module\_la\_mcp\_api) | ./modules/core/gateway/apim-api/mcp-api | n/a |
| <a name="module_la_mcp_storage"></a> [la\_mcp\_storage](#module\_la\_mcp\_storage) | ./modules/core/storage | n/a |
| <a name="module_mcp_product"></a> [mcp\_product](#module\_mcp\_product) | ./modules/core/gateway/mcp-product | n/a |
| <a name="module_oauth_app"></a> [oauth\_app](#module\_oauth\_app) | ./modules/core/gateway/apim-api/oauth-api | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.common_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.hello_project1_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_application.oauth_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_identifier_uri.entra_app_uri](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_identifier_uri) | resource |
| [azuread_application_permission_scope.user_impersonation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_permission_scope) | resource |
| [azuread_application_pre_authorized.oauth_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_pre_authorized) | resource |
| [azuread_service_principal.oauth_app_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurecaf_name.ai_appinsights_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.apim_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.funcmcp_storage_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.la_mcp_storage_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.law_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.rg_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_application_insights.ai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_user_assigned_identity.mcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_uuid.common](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.hello_project1](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.hello_project2](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.user_impersonation_scope_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The name of the azd environment to be deployed | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AZURE_LOCATION"></a> [AZURE\_LOCATION](#output\_AZURE\_LOCATION) | n/a |
| <a name="output_FUNC_MCP_ENDPOINTS"></a> [FUNC\_MCP\_ENDPOINTS](#output\_FUNC\_MCP\_ENDPOINTS) | n/a |
| <a name="output_LOGICAPP_MCP_ENDPOINTS"></a> [LOGICAPP\_MCP\_ENDPOINTS](#output\_LOGICAPP\_MCP\_ENDPOINTS) | n/a |
| <a name="output_OAUTH_APP_ID"></a> [OAUTH\_APP\_ID](#output\_OAUTH\_APP\_ID) | n/a |
| <a name="output_RESOURCE_GROUP_NAME"></a> [RESOURCE\_GROUP\_NAME](#output\_RESOURCE\_GROUP\_NAME) | n/a |
<!-- END_TF_DOCS -->