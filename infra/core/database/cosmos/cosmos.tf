terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.24"
    }
  }
}
# ------------------------------------------------------------------------------------------------------
# Deploy cosmos db account
# ------------------------------------------------------------------------------------------------------
resource "azurecaf_name" "db_acc_name" {
  name          = var.resource_token
  resource_type = "azurerm_cosmosdb_account"
  random_length = 0
  clean_input   = true
}

resource "azurerm_cosmosdb_account" "db" {
  name                             = azurecaf_name.db_acc_name.result
  location                         = var.location
  resource_group_name              = var.rg_name
  offer_type                       = "Standard"
  kind                             = "MongoDB"
  automatic_failover_enabled       = false
  multiple_write_locations_enabled = false
  mongo_server_version             = "4.0"
  tags                             = var.tags

  capabilities {
    name = "EnableServerless"
  }

  lifecycle {
    ignore_changes = [capabilities]
  }
  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
    zone_redundant    = false
  }
}

# ------------------------------------------------------------------------------------------------------
# Deploy cosmos mongo db and collections
# ------------------------------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  name                = "Todo"
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
}

resource "azurerm_cosmosdb_mongo_collection" "list" {
  name                = "TodoList"
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
  database_name       = azurerm_cosmosdb_mongo_database.mongodb.name
  shard_key           = "_id"


  index {
    keys = ["_id"]
  }
}

resource "azurerm_cosmosdb_mongo_collection" "item" {
  name                = "TodoItem"
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
  database_name       = azurerm_cosmosdb_mongo_database.mongodb.name
  shard_key           = "_id"

  index {
    keys = ["_id"]
  }
}
