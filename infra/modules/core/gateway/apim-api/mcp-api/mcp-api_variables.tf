variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "apim_service_name" {
  description = "API Management service name"
  type        = string
}

variable "api_management_id" {
  description = "API Management resource ID (for parent_id)"
  type        = string
}

variable "api_name" {
  description = "API name"
  type        = string
}

variable "mcp_url" {
  description = "Endpoint URL of mcp"
  type        = string
}

variable "mcp_api_uri_template" {
  description = "URI template for MCP API"
  type        = string
}

variable "api_management_logger_id" {
  description = "The resource ID of the Application Insights logger for APIM diagnostics"
  type        = string
}

variable "sampling_percentage" {
  description = "Percentage of requests to log to Application Insights (0.0 to 100.0)"
  type        = number
  default     = 100.0
}
