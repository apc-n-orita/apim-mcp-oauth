# For func_auth
variable "azuread_application_entra_app_client_id" {
  type        = string
  description = "Client ID of the Entra ID application for AAD auth"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD Tenant ID"
}

variable "apim_principal_id" {
  type        = string
  description = "Principal ID of APIM Managed Identity (for allowedPrincipals)"
}

# Additional variable for Function App azapi_resource
variable "identity_id" {
  type        = string
  description = "Resource ID of the user-assigned identity"
}

variable "kind" {
  type        = string
  description = "Kind of the Function App (e.g. functionapp,linux)"
  default     = "functionapp,linux"
}

variable "instance_memory_mb" {
  type        = number
  description = "Memory (MB) per instance for scaleAndConcurrency"
  default     = 2048
}

variable "maximum_instance_count" {
  type        = number
  description = "Maximum instance count for scaleAndConcurrency"
  default     = 100
}

variable "runtime_name" {
  type        = string
  description = "Runtime name (e.g. python)"
  default     = "python"
}

variable "runtime_version" {
  type        = string
  description = "Runtime version (e.g. 3.10)"
  default     = "3.11"
}

variable "name" {
  type        = string
  description = "Function App name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "rg_id" {
  type        = string
  description = "Resource group ID"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply"
}

variable "app_service_plan_id" {
  type        = string
  description = "App Service Plan resource ID"
}

variable "app_settings" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Additional app settings as a list of name/value pairs"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name for Function App"
}
variable "function_storage_id" {
  type        = string
  description = "Storage account ID for Function App"
}

variable "primary_blob_endpoint" {
  type        = string
  description = "Primary Blob Endpoint of the storage account"
}

#variable "virtual_network_subnet_id" {
#  type        = string
#  default     = ""
#  description = "Subnet ID for VNet integration"
#}

#variable "identitytype" {
#  description = "The type of Managed Identity used for the Function App. Possible values: SystemAssigned, UserAssigned"
#  type        = string
#  default     = "UserAssigned"
#  validation {
#    condition     = contains(["SystemAssigned, UserAssigned", "UserAssigned"], var.identitytype)
#    error_message = "Allowed values for identity_type are: 'SystemAssigned, UserAssigned', UserAssigned"
#  }
#}


variable "application_insights_connection_string" {
  type        = string
  description = "Application Insights connection string"
}


variable "identity_client_id" {
  type        = string
  description = "Client ID of the user-assigned identity"
}

