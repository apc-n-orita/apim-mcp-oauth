# Input variables for the module

variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "ops_allowed_principal_ids" {
  description = "OIDs of users or service principals allowed to access the Function App directly (bypassing APIM), for ops troubleshooting"
  type        = list(string)
  default     = []
}
