# Declare output values for the main terraform module.
#
# This allows the main terraform module outputs to be referenced by other modules,
# or by the local machine as a way to reference created resources in Azure for local development.
# Secrets should not be added here.
#
# Outputs are automatically saved in the local azd environment .env file.
# To see these outputs, run `azd env get-values`. `azd env get-values --output json` for json output.

output "AZURE_LOCATION" {
  value = var.location
}

output "RESOURCE_GROUP_NAME" {
  value = azurerm_resource_group.rg.name
}

output "FUNC_MCP_ENDPOINTS" {
  value = "${module.apim.gateway_url}/${module.func_mcp_api.api_name}${module.func_mcp_api.api_uri_template}"
}

output "LOGICAPP_MCP_ENDPOINTS" {
  value = "${module.apim.gateway_url}/${module.la_mcp_api.api_name}${module.la_mcp_api.api_uri_template}"
}

output "OAUTH_APP_ID" {
  value = azuread_application.oauth_app.client_id
}
