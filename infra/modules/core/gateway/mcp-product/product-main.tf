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
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.0.0"
    }
  }
}

resource "azurerm_api_management_product" "product" {
  product_id            = var.product_name
  api_management_name   = var.api_management_name
  resource_group_name   = var.resource_group_name
  display_name          = var.product_name
  description           = "Product for ${var.product_name}"
  subscription_required = false
  approval_required     = false
  published             = true
}


resource "azapi_resource" "product_mcp" {
  for_each                  = { for idx, id in var.api_ids : idx => id }
  type                      = "Microsoft.ApiManagement/service/products/apiLinks@2025-03-01-preview"
  schema_validation_enabled = false
  name                      = substr(replace(base64encode(sha256(each.value)), "[^A-Za-z0-9]", ""), 0, 24)
  parent_id                 = azurerm_api_management_product.product.id
  body = {
    properties = {
      apiId = each.value
    }
  }
}

resource "azurerm_api_management_product_policy" "product" {
  product_id          = azurerm_api_management_product.product.product_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  xml_content = templatefile("${path.module}/files/policy/mcp_api_policy.xml", {
    oauth-app-id    = azurerm_api_management_named_value.oauth_app_id.name
    EntraIDTenantId = azurerm_api_management_named_value.entra_id_tenant_id.name
  })
}

resource "azurerm_api_management_named_value" "oauth_app_id" {
  name                = "oauth-app-id"
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  display_name        = "oauth-app-id"
  value               = var.oauth_app_id
}

resource "azurerm_api_management_named_value" "entra_id_tenant_id" {
  name                = "EntraIDTenantId"
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  display_name        = "EntraIDTenantId"
  value               = var.tenant_id
}
