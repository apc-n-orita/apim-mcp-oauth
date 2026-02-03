variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "sku" {
  description = "The pricing tier of this API Management service."
  type        = string
  default     = "Consumption"
}

variable "application_insights_name" {
  description = "Azure Application Insights Name."
  type        = string
}

variable "skuCount" {
  description = "The instance size of this API Management service. @allowed([ 0, 1, 2 ])"
  type        = string
  default     = "0"
}

variable "name" {
  type = string
}

variable "publisher_email" {
  description = "The email address of the owner of the service."
  type        = string
  default     = "noreply@microsoft.com"
}

variable "publisher_name" {
  description = "The name of the owner of the service"
  type        = string
  default     = "n/a"
}

variable "azurerm_user_assigned_identity_id" {
  description = "The User Assigned Identity Resource ID to be associated with the APIM instance"
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace used commonly"
  type        = string
}

variable "identity_type" {
  description = "The type of Managed Identity used for the APIM instance. Possible values are: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None"
  type        = string
  default     = "SystemAssigned"
  validation {
    condition     = contains(["SystemAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Allowed values for identity_type are: 'SystemAssigned, UserAssigned', SystemAssigned,"
  }
}
