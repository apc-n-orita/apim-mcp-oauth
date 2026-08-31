variable "resource_group_name" {
  description = "Resource group name of the existing API Management instance"
  type        = string
}

variable "apim_service_name" {
  description = "The name of the API Management service"
  type        = string
}

variable "api_management_logger_id" {
  description = "The resource ID of the Application Insights logger for APIM diagnostics."
  type        = string
}

variable "api_name" {
  description = "Name of the API on APIM"
  type        = string
  default     = "oauth"
}

variable "api_path" {
  description = "Path of the API on APIM (no leading/trailing slash). Fixed to the RFC 9728 well-known path so MCP-server-specific operations (see the mcp-prm-operation module) can be added underneath it."
  type        = string
  default     = ".well-known/oauth-protected-resource"
}

variable "sampling_percentage" {
  description = "Percentage of requests to log to Application Insights (0.0 to 100.0)"
  type        = number
  default     = 100.0
}
