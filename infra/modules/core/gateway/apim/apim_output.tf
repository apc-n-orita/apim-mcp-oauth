output "APIM_SERVICE_NAME" {
  value = azurerm_api_management.apim.name
}

output "API_MANAGEMENT_LOGGER_ID" {
  value = azapi_resource.apim_logger.id
}

output "gateway_url" {
  value = azurerm_api_management.apim.gateway_url
}

output "apim_principal_id" {
  value = azurerm_api_management.apim.identity[0].principal_id
}

output "APIM_ID" {
  value = azurerm_api_management.apim.id
}
