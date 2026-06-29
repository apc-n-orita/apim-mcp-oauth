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

| Name                                                                                                                                                                       | Type     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_monitor_diagnostic_setting.storage_blob_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)  | resource |
| [azurerm_monitor_diagnostic_setting.storage_file_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)  | resource |
| [azurerm_monitor_diagnostic_setting.storage_queue_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storage_table_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_storage_account.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)                                            | resource |

## Inputs

| Name                                                                                                                           | Description                                                                                                         | Type          | Default      | Required |
| ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- | ------------- | ------------ | :------: |
| <a name="input_location"></a> [location](#input_location)                                                                      | The Azure region where the storage account will be created.                                                         | `string`      | n/a          |   yes    |
| <a name="input_log_analytics_workspace_id"></a> [log_analytics_workspace_id](#input_log_analytics_workspace_id)                | The ID of the Log Analytics workspace for diagnostics.                                                              | `string`      | n/a          |   yes    |
| <a name="input_name"></a> [name](#input_name)                                                                                  | The name of the storage account.                                                                                    | `string`      | n/a          |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                                     | The name of the resource group in which to create the storage account.                                              | `string`      | n/a          |   yes    |
| <a name="input_allow_nested_items_to_be_public"></a> [allow_nested_items_to_be_public](#input_allow_nested_items_to_be_public) | Allow nested items (blobs and directories) within containers and directories to be set as public.                   | `bool`        | `false`      |    no    |
| <a name="input_is_hns_enabled"></a> [is_hns_enabled](#input_is_hns_enabled)                                                    | Whether to enable hierarchical namespace. Required for Data Lake Storage Gen2. Once enabled, it cannot be disabled. | `bool`        | `false`      |    no    |
| <a name="input_replication_type"></a> [replication_type](#input_replication_type)                                              | The replication type of the storage account. Possible values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS                    | `string`      | `"LRS"`      |    no    |
| <a name="input_shared_access_key_enabled"></a> [shared_access_key_enabled](#input_shared_access_key_enabled)                   | Whether shared access key authentication is enabled for the storage account.                                        | `bool`        | `false`      |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                  | A mapping of tags to assign to the resource.                                                                        | `map(string)` | `{}`         |    no    |
| <a name="input_tier"></a> [tier](#input_tier)                                                                                  | The performance tier of the storage account. Possible values: Standard, Premium                                     | `string`      | `"Standard"` |    no    |

## Outputs

| Name                                                                                                                          | Description |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_name"></a> [name](#output_name)                                                                               | n/a         |
| <a name="output_primary_access_key"></a> [primary_access_key](#output_primary_access_key)                                     | n/a         |
| <a name="output_primary_blob_connection_string"></a> [primary_blob_connection_string](#output_primary_blob_connection_string) | n/a         |
| <a name="output_primary_blob_endpoint"></a> [primary_blob_endpoint](#output_primary_blob_endpoint)                            | n/a         |
| <a name="output_storage_account_id"></a> [storage_account_id](#output_storage_account_id)                                     | n/a         |

<!-- END_TF_DOCS -->
