<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                               | Version  |
| ------------------------------------------------------------------ | -------- |
| <a name="requirement_azapi"></a> [azapi](#requirement_azapi)       | ~>2.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~>4.42.0 |

## Providers

| Name                                                         | Version  |
| ------------------------------------------------------------ | -------- |
| <a name="provider_azapi"></a> [azapi](#provider_azapi)       | ~>2.0.0  |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~>4.42.0 |

## Resources

| Name                                                                                                                                                         | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [azapi_resource.apim_logger](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource)                                             | resource    |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management)                                | resource    |
| [azurerm_api_management_diagnostic.all-api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_diagnostic)       | resource    |
| [azurerm_monitor_diagnostic_setting.apim_logger](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource    |
| [azurerm_role_assignment.monitoring_metrics_publisher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)      | resource    |
| [azurerm_application_insights.appinsights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights)          | data source |

## Inputs

| Name                                                                                                                                 | Description                                                                                                                                    | Type          | Default                   | Required |
| ------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------------------- | :------: |
| <a name="input_application_insights_name"></a> [application_insights_name](#input_application_insights_name)                         | Azure Application Insights Name.                                                                                                               | `string`      | n/a                       |   yes    |
| <a name="input_location"></a> [location](#input_location)                                                                            | The supported Azure location where the resource deployed                                                                                       | `string`      | n/a                       |   yes    |
| <a name="input_log_analytics_workspace_id"></a> [log_analytics_workspace_id](#input_log_analytics_workspace_id)                      | Resource ID of the Log Analytics Workspace used commonly                                                                                       | `string`      | n/a                       |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                                        | n/a                                                                                                                                            | `string`      | n/a                       |   yes    |
| <a name="input_rg_name"></a> [rg_name](#input_rg_name)                                                                               | The name of the resource group to deploy resources into                                                                                        | `string`      | n/a                       |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                        | A list of tags used for deployed services.                                                                                                     | `map(string)` | n/a                       |   yes    |
| <a name="input_azurerm_user_assigned_identity_id"></a> [azurerm_user_assigned_identity_id](#input_azurerm_user_assigned_identity_id) | The User Assigned Identity Resource ID to be associated with the APIM instance                                                                 | `string`      | `""`                      |    no    |
| <a name="input_identity_type"></a> [identity_type](#input_identity_type)                                                             | The type of Managed Identity used for the APIM instance. Possible values are: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None | `string`      | `"SystemAssigned"`        |    no    |
| <a name="input_publisher_email"></a> [publisher_email](#input_publisher_email)                                                       | The email address of the owner of the service.                                                                                                 | `string`      | `"noreply@microsoft.com"` |    no    |
| <a name="input_publisher_name"></a> [publisher_name](#input_publisher_name)                                                          | The name of the owner of the service                                                                                                           | `string`      | `"n/a"`                   |    no    |
| <a name="input_sku"></a> [sku](#input_sku)                                                                                           | The pricing tier of this API Management service.                                                                                               | `string`      | `"Consumption"`           |    no    |
| <a name="input_skuCount"></a> [skuCount](#input_skuCount)                                                                            | The instance size of this API Management service. @allowed([ 0, 1, 2 ])                                                                        | `string`      | `"0"`                     |    no    |

## Outputs

| Name                                                                                                        | Description |
| ----------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_APIM_SERVICE_NAME"></a> [APIM_SERVICE_NAME](#output_APIM_SERVICE_NAME)                      | n/a         |
| <a name="output_API_MANAGEMENT_LOGGER_ID"></a> [API_MANAGEMENT_LOGGER_ID](#output_API_MANAGEMENT_LOGGER_ID) | n/a         |
| <a name="output_gateway_url"></a> [gateway_url](#output_gateway_url)                                        | n/a         |

<!-- END_TF_DOCS -->
