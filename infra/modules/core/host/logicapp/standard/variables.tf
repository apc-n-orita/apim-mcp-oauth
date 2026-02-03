variable "name" {
  description = "The name of the Logic App Standard"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "rg_name" {
  description = "The resource group name"
  type        = string
}

variable "rg_id" {
  description = "The resource ID of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "The SKU name of the App Service Plan"
  type        = string
}

variable "storage_account_id" {
  description = "The resource ID of the storage account"
  type        = string
}

variable "storage_account_name" {
  description = "The storage account name"
  type        = string
}

variable "storage_account_access_key" {
  description = "The storage account access key (for Azure Files)"
  type        = string
  sensitive   = true
}

variable "user_assigned_identity_id" {
  description = "The resource ID of the User-Assigned Managed Identity"
  type        = string
}

variable "user_assigned_identity_client_id" {
  description = "The Client ID of the User-Assigned Managed Identity"
  type        = string
}

variable "user_assigned_identity_principal_id" {
  description = "The Principal ID of the User-Assigned Managed Identity"
  type        = string
}

variable "application_insights_connection_string" {
  description = "The Application Insights connection string"
  type        = string
}

variable "functions_extension_version" {
  description = "The Azure Functions extension version"
  type        = string
  default     = "~4"
}

variable "powershell_version" {
  description = "The PowerShell runtime version"
  type        = string
  default     = "7.4"
}

variable "node_version" {
  description = "The Node.js runtime version"
  type        = string
  default     = "~18"
}

variable "extension_bundle_version" {
  description = "The Logic Apps Extension Bundle version range"
  type        = string
  default     = "[1.*, 2.0.0)"
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "azuread_application_entra_app_client_id" {
  description = "The Client ID of the Entra ID app (for authsettings)"
  type        = string
}

variable "apim_principal_id" {
  description = "The Principal ID of the APIM Managed Identity (for authsettings)"
  type        = string
}
