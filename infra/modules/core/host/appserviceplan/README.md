<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                               | Version  |
| ------------------------------------------------------------------ | -------- |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~>4.60.0 |

## Providers

| Name                                                         | Version  |
| ------------------------------------------------------------ | -------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~>4.60.0 |

## Resources

| Name                                                                                                                      | Type     |
| ------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_service_plan.plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |

## Inputs

| Name                                                      | Description                                                  | Type          | Default   | Required |
| --------------------------------------------------------- | ------------------------------------------------------------ | ------------- | --------- | :------: |
| <a name="input_location"></a> [location](#input_location) | The supported Azure location where the resource deployed     | `string`      | n/a       |   yes    |
| <a name="input_name"></a> [name](#input_name)             | The name of the App Service Plan.                            | `string`      | n/a       |   yes    |
| <a name="input_rg_name"></a> [rg_name](#input_rg_name)    | The name of the resource group to deploy resources into      | `string`      | n/a       |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)             | A list of tags used for deployed services.                   | `map(string)` | n/a       |   yes    |
| <a name="input_os_type"></a> [os_type](#input_os_type)    | The O/S type for the App Services to be hosted in this plan. | `string`      | `"Linux"` |    no    |
| <a name="input_sku_name"></a> [sku_name](#input_sku_name) | The SKU for the plan.                                        | `string`      | `"B1"`    |    no    |

## Outputs

| Name                                                                                      | Description |
| ----------------------------------------------------------------------------------------- | ----------- |
| <a name="output_APPSERVICE_PLAN_ID"></a> [APPSERVICE_PLAN_ID](#output_APPSERVICE_PLAN_ID) | n/a         |

<!-- END_TF_DOCS -->
