# Logic App
output "logicapp_id" {
  description = "Logic App Standard のリソースID"
  value       = azapi_resource.logicapp.id
}

output "logicapp_name" {
  description = "Logic App Standard の名前"
  value       = azapi_resource.logicapp.name
}

output "logicapp_default_hostname" {
  description = "Logic App のデフォルトホスト名"
  value       = azapi_resource.logicapp.output.properties.defaultHostName
}

output "logicapp_system_principal_id" {
  description = "Logic App の System-Assigned Managed Identity Principal ID"
  value       = azapi_resource.logicapp.output.identity.principalId
}

# App Service Plan
output "service_plan_id" {
  description = "App Service Plan のリソースID"
  value       = azurerm_service_plan.logicapp_plan.id
}

