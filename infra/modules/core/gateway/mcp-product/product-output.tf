output "product_id" {
  description = "The ID of the created APIM product"
  value       = azurerm_api_management_product.product.id
}

output "product_name" {
  description = "The APIM product name"
  value       = azurerm_api_management_product.product.product_id
}

