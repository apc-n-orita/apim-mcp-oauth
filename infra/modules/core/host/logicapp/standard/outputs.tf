# Logic App
output "logicapp_id" {
  description = "The resource ID of the Logic App Standard"
  value       = azapi_resource.logicapp.id
}

output "logicapp_name" {
  description = "The name of the Logic App Standard"
  value       = azapi_resource.logicapp.name
}

output "logicapp_default_hostname" {
  description = "The default hostname of the Logic App"
  value       = azapi_resource.logicapp.output.properties.defaultHostName
}

output "logicapp_system_principal_id" {
  description = "The System-Assigned Managed Identity Principal ID of the Logic App"
  value       = azapi_resource.logicapp.output.identity.principalId
}

# App Service Plan
output "service_plan_id" {
  description = "The resource ID of the App Service Plan"
  value       = azurerm_service_plan.logicapp_plan.id
}

