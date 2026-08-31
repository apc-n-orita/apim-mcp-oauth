terraform {
  required_providers {
    azurerm = {
      version = "~>4.60.0"
      source  = "hashicorp/azurerm"
    }
  }
}

# Microsoft公式サンプル (Azure-Samples/AI-Gateway, labs/mcp-prm-oauth の
# mcp-api.bicep / mcp-prm.policy.xml) を踏襲した、MCPサーバー1台分の
# OAuth 2.0 Protected Resource Metadata (RFC 9728) オペレーション。
# 共有の PRM ディスカバリーAPI (oauth-api モジュール, path=/.well-known/oauth-protected-resource)
# の配下に、このMCPサーバー専用のパス (/<mcp_endpoint_path>) でオペレーションを追加する。
# mcp_endpoint_path には、実際のMCPクライアント向けURL (ゲートウェイURLより後ろ・クエリ文字列を除く部分)
# をそのまま渡すこと。MCPサーバーごとにuriTemplateの形が異なるため、
# ここで "/mcp" などを自動付与しない。
locals {
  url_template = "/${var.mcp_endpoint_path}"
}

resource "azurerm_api_management_api_operation" "get" {
  operation_id        = "prm-get-${var.mcp_server_id}"
  api_name            = var.prm_api_name
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  display_name        = "PRM: ${var.mcp_server_id}"
  method              = "GET"
  url_template        = local.url_template
  description         = "OAuth 2.0 Protected Resource Metadata for the ${var.mcp_server_id} MCP server"
}

resource "azurerm_api_management_api_operation_policy" "get" {
  api_name            = var.prm_api_name
  operation_id        = azurerm_api_management_api_operation.get.operation_id
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  xml_content = templatefile("${path.module}/files/policy/mcp_prm_get_policy.xml", {
    apim_gateway_url   = var.apim_gateway_url
    mcp_endpoint_path  = var.mcp_endpoint_path
    mcp_endpoint_query = var.mcp_endpoint_query
    scope              = var.scope
  })
}

resource "azurerm_api_management_api_operation" "options" {
  operation_id        = "prm-options-${var.mcp_server_id}"
  api_name            = var.prm_api_name
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  display_name        = "PRM CORS preflight: ${var.mcp_server_id}"
  method              = "OPTIONS"
  url_template        = local.url_template
  description         = "CORS preflight request handler for the ${var.mcp_server_id} Protected Resource Metadata endpoint"
}

resource "azurerm_api_management_api_operation_policy" "options" {
  api_name            = var.prm_api_name
  operation_id        = azurerm_api_management_api_operation.options.operation_id
  api_management_name = var.apim_service_name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/mcp_prm_options_policy.xml")
}
