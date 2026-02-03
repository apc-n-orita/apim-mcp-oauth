output "product_id" {
  description = "作成されたAPIMプロダクトのID"
  value       = azurerm_api_management_product.product.id
}

output "product_name" {
  description = "APIMプロダクト名"
  value       = azurerm_api_management_product.product.product_id
}

