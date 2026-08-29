terraform {
  required_providers {
    azurerm = {
      version = "~>4.60.0"
      source  = "hashicorp/azurerm"
    }
  }
}

# Microsoft公式サンプル (Azure-Samples/AI-Gateway, labs/mcp-prm-oauth の
# "mcp-prm-dynamic-discovery" API) を踏襲した、MCPサーバー共通の
# OAuth 2.0 Protected Resource Metadata (RFC 9728) 動的ディスカバリーAPI。
# このAPI自体はpath="/.well-known/oauth-protected-resource"に固定するだけで、
# MCPサーバーごとに異なるリソースパス・スコープを返すオペレーションは
# mcp-prm-operation モジュールで個別に追加する (このAPIの配下に相乗り)。
resource "azurerm_api_management_api" "oauth" {
  name                  = var.api_name
  resource_group_name   = var.resource_group_name
  api_management_name   = var.apim_service_name
  revision              = "1"
  display_name          = "MCP Protected Resource Metadata (RFC 9728)"
  description           = "Dynamic discovery endpoint for MCP servers' OAuth 2.0 Protected Resource Metadata"
  subscription_required = false
  path                  = var.api_path
  protocols             = ["https"]
}

resource "azurerm_api_management_api_diagnostic" "oauth" {
  identifier                = "applicationinsights"
  api_name                  = azurerm_api_management_api.oauth.name
  api_management_name       = var.apim_service_name
  resource_group_name       = var.resource_group_name
  api_management_logger_id  = var.api_management_logger_id
  sampling_percentage       = var.sampling_percentage
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
