<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~>1.2.24 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.97.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | ~>1.2.24 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.97.1 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.web_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_linux_web_app.web](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_command_line"></a> [app\_command\_line](#input\_app\_command\_line) | The cmd line to configure the app to run. | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | A list of app settings pairs to be assigned to the app service | `map(string)` | n/a | yes |
| <a name="input_appservice_plan_id"></a> [appservice\_plan\_id](#input\_appservice\_plan\_id) | The id of the appservice plan to use. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_resource_token"></a> [resource\_token](#input\_resource\_token) | A suffix string to centrally mitigate resource name collisions. | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group to deploy resources into | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | A name to reflect the type of the app service e.g: web, api. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags used for deployed services. | `map(string)` | n/a | yes |
| <a name="input_identity"></a> [identity](#input\_identity) | A list of application identity | `list(any)` | `[]` | no |
| <a name="input_java_version"></a> [java\_version](#input\_java\_version) | the application stack java version to set for the app service. | `string` | `"17"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_IDENTITY_PRINCIPAL_ID"></a> [IDENTITY\_PRINCIPAL\_ID](#output\_IDENTITY\_PRINCIPAL\_ID) | n/a |
| <a name="output_URI"></a> [URI](#output\_URI) | n/a |
<!-- END_TF_DOCS -->