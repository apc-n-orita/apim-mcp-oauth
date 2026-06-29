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

## Resources

| Name                                                                                                                                                                | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azapi_resource.product_mcp](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource)                                                    | resource |
| [azurerm_api_management_named_value.entra_id_tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.oauth_app_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)       | resource |
| [azurerm_api_management_product.product](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product)                    | resource |
| [azurerm_api_management_product_policy.product](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product_policy)      | resource |

## Inputs

| Name                                                                                       | Description                                  | Type           | Default | Required |
| ------------------------------------------------------------------------------------------ | -------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_api_ids"></a> [api_ids](#input_api_ids)                                     | List of API IDs associated with this product | `list(string)` | n/a     |   yes    |
| <a name="input_api_management_name"></a> [api_management_name](#input_api_management_name) | APIM service name                            | `string`       | n/a     |   yes    |
| <a name="input_oauth_app_id"></a> [oauth_app_id](#input_oauth_app_id)                      | Client ID of the OAuth app                   | `string`       | n/a     |   yes    |
| <a name="input_product_name"></a> [product_name](#input_product_name)                      | Product name                                 | `string`       | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Resource group name                          | `string`       | n/a     |   yes    |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id)                               | Tenant ID                                    | `string`       | n/a     |   yes    |

## Outputs

| Name                                                                    | Description                        |
| ----------------------------------------------------------------------- | ---------------------------------- |
| <a name="output_product_id"></a> [product_id](#output_product_id)       | The ID of the created APIM product |
| <a name="output_product_name"></a> [product_name](#output_product_name) | The APIM product name              |

<!-- END_TF_DOCS -->
