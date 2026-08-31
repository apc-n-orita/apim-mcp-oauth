output "oauth_api_id" {
  description = "Resource ID of the oauth API"
  value       = azurerm_api_management_api.oauth.id
}

output "api_name" {
  description = "Name of the oauth API on APIM"
  value       = azurerm_api_management_api.oauth.name
}
