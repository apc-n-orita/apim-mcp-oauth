variable "name" {
  description = "Logic App Standard の名前"
  type        = string
}

variable "location" {
  description = "Azure リージョン"
  type        = string
}

variable "rg_name" {
  description = "リソースグループ名"
  type        = string
}

variable "rg_id" {
  description = "リソースグループのリソースID"
  type        = string
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "App Service PlanのSKU名"
  type        = string
}

variable "storage_account_id" {
  description = "ストレージアカウントの Resource ID"
  type        = string
}

variable "storage_account_name" {
  description = "ストレージアカウント名"
  type        = string
}

variable "storage_account_access_key" {
  description = "ストレージアカウントのアクセスキー (Azure Files 用)"
  type        = string
  sensitive   = true
}

variable "user_assigned_identity_id" {
  description = "User-Assigned Managed Identity のリソースID"
  type        = string
}

variable "user_assigned_identity_client_id" {
  description = "User-Assigned Managed Identity の Client ID"
  type        = string
}

variable "user_assigned_identity_principal_id" {
  description = "User-Assigned Managed Identity の Principal ID"
  type        = string
}

variable "application_insights_connection_string" {
  description = "Application Insights 接続文字列"
  type        = string
}

variable "functions_extension_version" {
  description = "Azure Functions 拡張バージョン"
  type        = string
  default     = "~4"
}

variable "powershell_version" {
  description = "PowerShell ランタイムバージョン"
  type        = string
  default     = "7.4"
}

variable "node_version" {
  description = "Node.js ランタイムバージョン"
  type        = string
  default     = "~18"
}

variable "extension_bundle_version" {
  description = "Logic Apps Extension Bundle のバージョン範囲"
  type        = string
  default     = "[1.*, 2.0.0)"
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "azuread_application_entra_app_client_id" {
  description = "Entra IDアプリのClient ID (authsettings用)"
  type        = string
}

variable "apim_principal_id" {
  description = "APIMのManaged IdentityのPrincipal ID (authsettings用)"
  type        = string
}
