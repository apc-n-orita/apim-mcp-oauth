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

| Name                                                                                                                                                    | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_role_assignment.blob_data_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)              | resource |
| [azurerm_role_assignment.monitoring_metrics_publisher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.queue_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)       | resource |
| [azurerm_role_assignment.table_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)       | resource |

## Inputs

| Name                                                                                                                                       | Description                             | Type     | Default | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------- | -------- | ------- | :------: |
| <a name="input_monitor_scope_id"></a> [monitor_scope_id](#input_monitor_scope_id)                                                          | The scope for monitoring                | `string` | n/a     |   yes    |
| <a name="input_storage_account_scope_id"></a> [storage_account_scope_id](#input_storage_account_scope_id)                                  | The scope of the storage account        | `string` | n/a     |   yes    |
| <a name="input_user_assigned_identity_principal_id"></a> [user_assigned_identity_principal_id](#input_user_assigned_identity_principal_id) | The user assigned identity principal ID | `string` | n/a     |   yes    |

<!-- END_TF_DOCS -->
