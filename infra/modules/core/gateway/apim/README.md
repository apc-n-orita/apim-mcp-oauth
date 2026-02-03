<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>2.0.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.42.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.apim_logger](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_diagnostic.all-api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_diagnostic) | resource |
| [azurerm_monitor_diagnostic_setting.apim_logger](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_role_assignment.monitoring_metrics_publisher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_application_insights.appinsights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_insights_name"></a> [application\_insights\_name](#input\_application\_insights\_name) | Azure Application Insights Name. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | 共通で使用する Log Analytics Workspace のリソース ID | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group to deploy resources into | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags used for deployed services. | `map(string)` | n/a | yes |
| <a name="input_azurerm_user_assigned_identity_id"></a> [azurerm\_user\_assigned\_identity\_id](#input\_azurerm\_user\_assigned\_identity\_id) | The User Assigned Identity Resource ID to be associated with the APIM instance | `string` | `""` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of Managed Identity used for the APIM instance. Possible values are: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None | `string` | `"SystemAssigned"` | no |
| <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email) | The email address of the owner of the service. | `string` | `"noreply@microsoft.com"` | no |
| <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name) | The name of the owner of the service | `string` | `"n/a"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The pricing tier of this API Management service. | `string` | `"Consumption"` | no |
| <a name="input_skuCount"></a> [skuCount](#input\_skuCount) | The instance size of this API Management service. @allowed([ 0, 1, 2 ]) | `string` | `"0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_APIM_SERVICE_NAME"></a> [APIM\_SERVICE\_NAME](#output\_APIM\_SERVICE\_NAME) | n/a |
| <a name="output_API_MANAGEMENT_LOGGER_ID"></a> [API\_MANAGEMENT\_LOGGER\_ID](#output\_API\_MANAGEMENT\_LOGGER\_ID) | n/a |
| <a name="output_gateway_url"></a> [gateway\_url](#output\_gateway\_url) | n/a |
<!-- END_TF_DOCS -->