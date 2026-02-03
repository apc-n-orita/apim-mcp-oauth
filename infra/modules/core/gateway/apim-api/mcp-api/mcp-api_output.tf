output "api_id" {
  value = azapi_resource.mcp_api.id
}

output "api_name" {
  value = azapi_resource.mcp_api.name
}

output "api_uri_template" {
  value = var.mcp_api_uri_template
}
