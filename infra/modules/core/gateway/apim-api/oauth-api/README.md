<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>3.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.42.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~>3.5.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.42.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~>3.7.0 |

## Resources

| Name | Type |
|------|------|
| [azuread_application.entra_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.fic](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azurerm_api_management_api.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_diagnostic.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_operation.oauth_authorize](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_callback](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_consent_get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_consent_post](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_metadata_get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_metadata_options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_register](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_register_options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.oauth_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation_policy.oauth_authorize_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_callback_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_consent_get_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_consent_post_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_metadata_get_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_metadata_options_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_register_options_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_register_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.oauth_token_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_named_value.CosmosDbContainer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.CosmosDbDatabase](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.CosmosDbEndpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.EncryptionIV](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.EncryptionKey](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.apim_gateway_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.entra_id_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.entra_id_fic_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.entra_id_tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.mcp_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.mcp_server_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.oauth_callback_uri](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.oauth_scopes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.token_ttl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [random_bytes.IV](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |
| [random_bytes.Key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_logger_id"></a> [api\_management\_logger\_id](#input\_api\_management\_logger\_id) | The resource ID of the Application Insights logger for APIM diagnostics. | `string` | n/a | yes |
| <a name="input_apim_service_name"></a> [apim\_service\_name](#input\_apim\_service\_name) | The name of the API Management service | `string` | n/a | yes |
| <a name="input_azureuser_object_id"></a> [azureuser\_object\_id](#input\_azureuser\_object\_id) | The object ID of the Azure user. | `string` | n/a | yes |
| <a name="input_cosmos_db_account_name"></a> [cosmos\_db\_account\_name](#input\_cosmos\_db\_account\_name) | The name of the Cosmos DB account. | `string` | n/a | yes |
| <a name="input_cosmos_db_container_name"></a> [cosmos\_db\_container\_name](#input\_cosmos\_db\_container\_name) | The name of the Cosmos DB container. | `string` | n/a | yes |
| <a name="input_cosmos_db_database_name"></a> [cosmos\_db\_database\_name](#input\_cosmos\_db\_database\_name) | The name of the Cosmos DB database. | `string` | n/a | yes |
| <a name="input_entra_app_display_name"></a> [entra\_app\_display\_name](#input\_entra\_app\_display\_name) | The display name of the Entra application. | `string` | n/a | yes |
| <a name="input_entra_app_tenant_id"></a> [entra\_app\_tenant\_id](#input\_entra\_app\_tenant\_id) | The Entra application's tenant ID (entraApp.outputs.entraAppTenantId) | `string` | n/a | yes |
| <a name="input_entra_app_uami_client_id"></a> [entra\_app\_uami\_client\_id](#input\_entra\_app\_uami\_client\_id) | The client ID of the user-assigned managed identity for Entra app. | `string` | n/a | yes |
| <a name="input_entra_app_uami_principal_id"></a> [entra\_app\_uami\_principal\_id](#input\_entra\_app\_uami\_principal\_id) | The principal ID of the user-assigned managed identity. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `any` | n/a | yes |
| <a name="input_token_ttl_seconds"></a> [token\_ttl\_seconds](#input\_token\_ttl\_seconds) | The TTL (in seconds) for tokens issued by the OAuth API. | `string` | `"3600"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_name"></a> [api\_name](#output\_api\_name) | n/a |
| <a name="output_entra_app_id"></a> [entra\_app\_id](#output\_entra\_app\_id) | n/a |
| <a name="output_entra_app_tenant_id"></a> [entra\_app\_tenant\_id](#output\_entra\_app\_tenant\_id) | n/a |
| <a name="output_oauth_api_id"></a> [oauth\_api\_id](#output\_oauth\_api\_id) | n/a |
<!-- END_TF_DOCS -->
