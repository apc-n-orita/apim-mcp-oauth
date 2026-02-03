variable "storage_account_scope_id" {
  description = "The scope of the storage account"
  type        = string
}

variable "monitor_scope_id" {
  description = "The scope for monitoring"
  type        = string
}

variable "user_assigned_identity_principal_id" {
  description = "The user assigned identity principal ID"
  type        = string

}
