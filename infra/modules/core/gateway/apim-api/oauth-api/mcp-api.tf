terraform {
  required_providers {
    azurerm = {
      version = "~>4.58.0"
      source  = "hashicorp/azurerm"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.7.0"
    }
  }
}


resource "azurerm_api_management_api" "oauth" {
  name                  = "oauth"
  resource_group_name   = var.resource_group_name
  api_management_name   = var.apim_service_name
  revision              = "1"
  display_name          = "OAuth"
  description           = "OAuth 2.0 Authentication API"
  subscription_required = false
  path                  = ""
  protocols             = ["https"]
  service_url           = "https://login.microsoftonline.com/${var.tenant_id}/oauth2/v2.0"
}

resource "azurerm_api_management_api_diagnostic" "oauth" {
  identifier                = "applicationinsights"
  api_name                  = azurerm_api_management_api.oauth.name
  api_management_name       = var.apim_service_name
  resource_group_name       = var.resource_group_name
  api_management_logger_id  = var.api_management_logger_id
  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes     = 0
    headers_to_log = []
  }

  frontend_response {
    body_bytes     = 0
    headers_to_log = []
  }

  backend_request {
    body_bytes     = 0
    headers_to_log = []
  }

  backend_response {
    body_bytes     = 0
    headers_to_log = []
  }
}

resource "azurerm_api_management_api_policy" "oauth" {
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/oauth_api_policy.xml")

}

# --- Operations & Policies ---
resource "azurerm_api_management_api_operation" "oauth_protected_resource_options" {
  operation_id        = "oauth-protected-resource-options"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  display_name        = "OAuth Protected Resource Options"
  method              = "OPTIONS"
  url_template        = "/.well-known/oauth-protected-resource"
  description         = "CORS preflight request handler for OAuth protected resource endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_protected_resource_options_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_protected_resource_options.operation_id
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/oauthprotected-resource-options_policy.xml")
}

resource "azurerm_api_management_api_operation" "oauth_protected_resource_get" {
  operation_id        = "oauth-protected-resource-get"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  display_name        = "OAuth Protected Resource Metadata Get"
  method              = "GET"
  url_template        = "/.well-known/oauth-protected-resource"
  description         = "GET OAuth Protected Resource Metadata"
}

resource "azurerm_api_management_api_operation_policy" "oauth_protected_resource_get_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_protected_resource_get.operation_id
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  xml_content = templatefile("${path.module}/files/policy/oauthprotected-resource-get_policy.xml", {
    APIMGatewayURL = azurerm_api_management_named_value.apim_gateway_url.name,
  })
  depends_on = []
}

resource "azurerm_api_management_named_value" "apim_gateway_url" {
  name                = "APIMGatewayURL"
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_service_name
  display_name        = "APIMGatewayURL"
  value               = var.apim_gateway_url
}

