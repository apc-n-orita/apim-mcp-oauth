# Configure desired versions of terraform, azurerm provider
terraform {
  required_version = ">= 1.1.7, < 2.0.0"
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.24"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.5.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.0.0"
    }

  }
}

# Enable features for azurerm
provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
  storage_use_azuread             = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {
}
# Access client_id, tenant_id, subscription_id and object_id configuration values
data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}
