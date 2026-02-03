terraform {
  required_providers {
    azurerm = {
      version = "~>4.58.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.0.0"
    }
  }
}


resource "azurerm_api_management_backend" "mcp" {
  name                = "mcp-backend-${var.api_name}"
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_service_name
  protocol            = "http"
  url                 = var.mcp_url
  description         = "Backend for ${var.api_name} mcp"
}


resource "azapi_resource" "mcp_api" {
  type                      = "Microsoft.ApiManagement/service/apis@2025-03-01-preview"
  name                      = var.api_name
  parent_id                 = var.api_management_id
  schema_validation_enabled = false

  body = {
    properties = {
      apiRevision          = "1"
      displayName          = var.api_name
      path                 = "${var.api_name}"
      protocols            = ["https"]
      type                 = "mcp"
      subscriptionRequired = false
      authenticationSettings = {
        oAuth2                          = null
        oAuth2AuthenticationSettings    = []
        openid                          = null
        openidAuthenticationSettings    = []
        returnProtectedResourceMetadata = false
      }
      mcpProperties = {
        endpoints = {
          mcp = {
            uriTemplate = var.mcp_api_uri_template
          }
        }
      }
      backendId   = azurerm_api_management_backend.mcp.name
      serviceUrl  = null
      description = null
      subscriptionKeyParameterNames = {
        header = "Ocp-Apim-Subscription-Key"
        query  = "subscription-key"
      }
    }
  }
}

resource "azurerm_api_management_api_policy" "mcp" {
  api_name            = azapi_resource.mcp_api.name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_service_name
  xml_content         = file("${path.module}/files/policy/mcp_api_policy.xml")
}

