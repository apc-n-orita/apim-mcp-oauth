variable "name" {
  description = "The name of the storage account."
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "shared_access_key_enabled" {
  description = "Whether shared access key authentication is enabled for the storage account."
  type        = bool
  default     = false
}
variable "tier" {
  description = "The performance tier of the storage account. Possible values: Standard, Premium"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.tier)
    error_message = "Allowed values for tier are: Standard, Premium"
  }
}

variable "replication_type" {
  description = "The replication type of the storage account. Possible values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "Allowed values for replication_type are: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS"
  }
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace for diagnostics."
  type        = string
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items (blobs and directories) within containers and directories to be set as public."
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "Whether to enable hierarchical namespace. Required for Data Lake Storage Gen2. Once enabled, it cannot be disabled."
  type        = bool
  default     = false
}
