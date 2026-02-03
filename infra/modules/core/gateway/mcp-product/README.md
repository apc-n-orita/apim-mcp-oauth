<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.58.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>2.0.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.58.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.product_mcp](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_api_management_named_value.entra_id_tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.oauth_app_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_product.product](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product_policy.product](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_ids"></a> [api\_ids](#input\_api\_ids) | List of API IDs associated with this product | `list(string)` | n/a | yes |
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | APIM service name | `string` | n/a | yes |
| <a name="input_oauth_app_id"></a> [oauth\_app\_id](#input\_oauth\_app\_id) | Client ID of the OAuth app | `string` | n/a | yes |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | Product name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_product_id"></a> [product\_id](#output\_product\_id) | The ID of the created APIM product |
| <a name="output_product_name"></a> [product\_name](#output\_product\_name) | The APIM product name |
<!-- END_TF_DOCS -->