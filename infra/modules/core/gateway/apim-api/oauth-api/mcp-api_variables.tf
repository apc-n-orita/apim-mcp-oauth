variable "resource_group_name" {}
variable "apim_service_name" {
  type        = string
  description = "The name of the API Management service"
}

variable "api_management_logger_id" {
  type        = string
  description = "The resource ID of the Application Insights logger for APIM diagnostics."
}

variable "apim_gateway_url" {
  type        = string
  description = "The gateway URL of the API Management service"
}

variable "tenant_id" {
  type        = string
  description = "The Entra ID (Azure AD) tenant ID"
}
