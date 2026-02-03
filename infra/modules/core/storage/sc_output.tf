output "name" {
  value = azurerm_storage_account.main.name
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}

output "primary_blob_connection_string" {
  value = azurerm_storage_account.main.primary_blob_connection_string
}

output "storage_account_id" {
  value = azurerm_storage_account.main.id
}

output "primary_access_key" {
  value = azurerm_storage_account.main.primary_access_key
}
