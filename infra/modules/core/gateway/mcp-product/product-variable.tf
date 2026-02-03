variable "api_management_name" {
  description = "APIM service name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "oauth_app_id" {
  description = "Client ID of the OAuth app"
  type        = string
}


variable "api_ids" {
  description = "List of API IDs associated with this product"
  type        = list(string)
}

variable "product_name" {
  description = "Product name"
  type        = string
}


variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}
