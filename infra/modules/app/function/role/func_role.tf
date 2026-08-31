terraform {
  required_providers {
    azurerm = {
      version = "~>4.60.0"
      source  = "hashicorp/azurerm"
    }
  }
}
resource "azurerm_role_assignment" "queue_data_contributor" {
  scope                = var.storage_account_scope_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.user_assigned_identity_principal_id
}

resource "azurerm_role_assignment" "blob_data_owner" {
  scope                = var.storage_account_scope_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.user_assigned_identity_principal_id
}

resource "azurerm_role_assignment" "table_data_contributor" {
  scope                = var.storage_account_scope_id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = var.user_assigned_identity_principal_id
}

