locals {
  tags           = { azd-env-name : var.environment_name }
  sha            = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
  apim = {
    sku             = "BasicV2"
    skuCount        = 1
    publisher_email = "testuser@example.com"
    publisher_name  = "testuser"
  }

  # Logic App Runtime Settings
  logicapp_runtime = {
    functions_extension_version = "~4"
    powershell_version          = "7.4"
    node_version                = "~22"
    extension_bundle_version    = "[1.*, 2.0.0)"
  }

  func = {
    tags = merge(local.tags, { azd-service-name = "funcmcp" })
    app_settings = [
      {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.mcp.client_id
      },
      {
        name  = "OTEL_SERVICE_NAME"
        value = "funcmcp"
      },
      {
        name  = "WEBSITE_AUTH_AAD_ALLOWED_TENANTS"
        value = data.azuread_client_config.current.tenant_id
      },
      {
        name  = "WEBSITE_AUTH_PRM_DEFAULT_WITH_SCOPES"
        value = "api://${azuread_application.oauth_app.client_id}/user_impersonation"
      },
      {
        name  = "PYTHON_APPLICATIONINSIGHTS_ENABLE_TELEMETRY"
        value = "true"
      },
      {
        name  = "OTEL_TRACES_SAMPLER"
        value = "parentbased_traceidratio"
      },
      {
        name  = "OTEL_TRACES_SAMPLER_ARG"
        value = "1"
      }
    ]
  }

}

resource "azurecaf_name" "rg_name" {
  name          = var.environment_name
  resource_type = "azurerm_resource_group"
  random_length = 0
  clean_input   = true
}


resource "azurecaf_name" "law_name" {
  name          = var.environment_name
  resource_type = "azurerm_log_analytics_workspace"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "apim_name" {
  name          = var.environment_name
  resource_type = "azurerm_api_management"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "ai_appinsights_name" {
  name          = var.environment_name
  resource_type = "azurerm_application_insights"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "funcmcp_storage_name" {
  name          = "func-mcp-${var.environment_name}"
  resource_type = "azurerm_storage_account"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "la_mcp_storage_name" {
  name          = "la-mcp-${var.environment_name}"
  resource_type = "azurerm_storage_account"
  random_length = 0
  clean_input   = true
}


# Deploy resource group
resource "azurerm_resource_group" "rg" {
  name     = "${azurecaf_name.rg_name.result}-${substr(local.resource_token, 0, 3)}"
  location = var.location
  // Tag the resource group with the azd environment name
  // This should also be applied to all resources created in this module
  tags = { azd-env-name : var.environment_name }
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${azurecaf_name.law_name.result}-${substr(local.resource_token, 0, 3)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


# Easy Auth (App Service Authentication) settings
resource "random_uuid" "user_impersonation_scope_id" {}
resource "random_uuid" "hello_project1" {}
resource "random_uuid" "hello_project2" {}
resource "random_uuid" "common" {}
resource "random_uuid" "secret" {}

resource "azuread_application" "oauth_app" {
  display_name = "mcp-oauth-app-${substr(local.resource_token, 0, 3)}"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Role for hello_project1"
    display_name         = "hello_project1"
    enabled              = true
    id                   = random_uuid.hello_project1.result # Fixed UUID (change if necessary)
    value                = "hello_project1"
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Role for hello_project2"
    display_name         = "hello_project2"
    enabled              = true
    id                   = random_uuid.hello_project2.result # Fixed UUID (change if necessary)
    value                = "hello_project2"
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Role for common"
    display_name         = "common_*"
    enabled              = true
    id                   = random_uuid.common.result # Fixed UUID (change if necessary)
    value                = "common_*"
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Role for secret"
    display_name         = "secret_*"
    enabled              = true
    id                   = random_uuid.secret.result # Fixed UUID (change if necessary)
    value                = "secret_*"
  }

  lifecycle {
    ignore_changes = [
      identifier_uris,
      api,
    ]
  }
}


resource "azuread_service_principal" "oauth_app_sp" {
  client_id = azuread_application.oauth_app.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Assign hello_project1 role to user
resource "azuread_app_role_assignment" "hello_project1_user" {
  principal_object_id = data.azuread_client_config.current.object_id
  app_role_id         = azuread_service_principal.oauth_app_sp.app_role_ids["hello_project1"]
  resource_object_id  = azuread_service_principal.oauth_app_sp.object_id
}


# Assign common role to user
resource "azuread_app_role_assignment" "common_user" {
  principal_object_id = data.azuread_client_config.current.object_id
  app_role_id         = azuread_service_principal.oauth_app_sp.app_role_ids["common_*"]
  resource_object_id  = azuread_service_principal.oauth_app_sp.object_id
}

# Set Application ID URI
resource "azuread_application_identifier_uri" "entra_app_uri" {
  application_id = azuread_application.oauth_app.id
  identifier_uri = "api://${azuread_application.oauth_app.client_id}"
}

# Set user_impersonation scope
resource "azuread_application_permission_scope" "user_impersonation" {
  application_id = azuread_application.oauth_app.id
  scope_id       = random_uuid.user_impersonation_scope_id.result
  value          = "user_impersonation"

  admin_consent_description  = "Allow the application to access mcp on behalf of the signed-in user."
  admin_consent_display_name = "Access mcp"
  user_consent_description   = "Allow the application to access mcp on your behalf."
  user_consent_display_name  = "Access mcp"
  type                       = "User" # Both admin and user can consent
}


resource "azuread_application_pre_authorized" "oauth_app" {
  application_id       = azuread_application.oauth_app.id
  authorized_client_id = "04b07795-8ddb-461a-bbee-02f9e1bf7b46" # Azure CLI

  permission_ids = [
    azuread_application_permission_scope.user_impersonation.scope_id,
  ]
}

resource "azurerm_application_insights" "ai" {
  name                          = "${azurecaf_name.ai_appinsights_name.result}-${substr(local.resource_token, 0, 3)}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  application_type              = "web"
  workspace_id                  = azurerm_log_analytics_workspace.law.id
  local_authentication_disabled = true
}


module "apim" {
  source                     = "./modules/core/gateway/apim"
  location                   = var.location
  rg_name                    = azurerm_resource_group.rg.name
  tags                       = local.tags
  sku                        = local.apim.sku
  skuCount                   = local.apim.skuCount
  name                       = "${azurecaf_name.apim_name.result}-${substr(local.resource_token, 0, 3)}"
  publisher_email            = local.apim.publisher_email
  publisher_name             = local.apim.publisher_name
  application_insights_name  = azurerm_application_insights.ai.name
  identity_type              = "SystemAssigned"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}


resource "azurerm_user_assigned_identity" "mcp" {
  name                = "mcp"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}


module "fC-appserviceplan" {
  source   = "./modules/core/host/appserviceplan"
  name     = "plan-func-${var.environment_name}-${substr(local.resource_token, 0, 3)}"
  location = var.location
  rg_name  = azurerm_resource_group.rg.name
  tags     = local.tags
  sku_name = "FC1"
  os_type  = "Linux"
}

module "func_mcp" {
  source                                 = "./modules/app/function/app"
  name                                   = "func-mcp-${var.environment_name}-${substr(local.resource_token, 0, 3)}"
  location                               = var.location
  rg_id                                  = azurerm_resource_group.rg.id
  tags                                   = local.func.tags
  app_service_plan_id                    = module.fC-appserviceplan.APPSERVICE_PLAN_ID
  app_settings                           = local.func.app_settings
  runtime_name                           = "python"
  runtime_version                        = "3.11"
  storage_account_name                   = module.func_mcp_storage.name
  function_storage_id                    = module.func_mcp_storage.storage_account_id
  primary_blob_endpoint                  = module.func_mcp_storage.primary_blob_endpoint
  application_insights_connection_string = azurerm_application_insights.ai.connection_string
  identity_client_id                     = azurerm_user_assigned_identity.mcp.client_id
  identity_id                            = azurerm_user_assigned_identity.mcp.id
  apim_principal_id                      = module.apim.apim_principal_id

  tenant_id                               = data.azuread_client_config.current.tenant_id
  azuread_application_entra_app_client_id = azuread_application.oauth_app.client_id

  depends_on = [module.func_mcp_storage]
}

module "func_mcp_role" {
  source                              = "./modules/app/function/role"
  storage_account_scope_id            = module.func_mcp_storage.storage_account_id
  monitor_scope_id                    = azurerm_application_insights.ai.id
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.mcp.principal_id
}

module "func_mcp_storage" {
  source                          = "./modules/core/storage"
  name                            = lower("${substr(replace(azurecaf_name.funcmcp_storage_name.result, "-", ""), 0, 20)}${substr(local.resource_token, 0, 3)}")
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  tags                            = local.tags
  shared_access_key_enabled       = false
  tier                            = "Standard"
  replication_type                = "LRS"
  is_hns_enabled                  = false
  allow_nested_items_to_be_public = false
  log_analytics_workspace_id      = azurerm_log_analytics_workspace.law.id
}


module "la_mcp_storage" {
  source                          = "./modules/core/storage"
  name                            = lower("${substr(replace(azurecaf_name.la_mcp_storage_name.result, "-", ""), 0, 20)}${substr(local.resource_token, 0, 3)}")
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  tags                            = local.tags
  shared_access_key_enabled       = true
  tier                            = "Standard"
  replication_type                = "LRS"
  is_hns_enabled                  = false
  allow_nested_items_to_be_public = false
  log_analytics_workspace_id      = azurerm_log_analytics_workspace.law.id

}

module "la_mcp" {
  source = "./modules/core/host/logicapp/standard"
  # Basic settings
  name     = "la-mcp-${var.environment_name}-${substr(local.resource_token, 0, 3)}"
  location = var.location
  rg_name  = azurerm_resource_group.rg.name
  rg_id    = azurerm_resource_group.rg.id
  tags     = merge(local.tags, { azd-service-name = "lamcp" })
  sku_name = "WS1"

  # Storage account settings
  storage_account_id         = module.la_mcp_storage.storage_account_id
  storage_account_name       = module.la_mcp_storage.name
  storage_account_access_key = module.la_mcp_storage.primary_access_key

  # Runtime settings
  functions_extension_version = local.logicapp_runtime.functions_extension_version
  powershell_version          = local.logicapp_runtime.powershell_version
  node_version                = local.logicapp_runtime.node_version
  extension_bundle_version    = local.logicapp_runtime.extension_bundle_version

  # Easy Auth settings
  tenant_id                               = data.azuread_client_config.current.tenant_id
  azuread_application_entra_app_client_id = azuread_application.oauth_app.client_id
  apim_principal_id                       = module.apim.apim_principal_id


  # Application Insights settings
  application_insights_connection_string = azurerm_application_insights.ai.connection_string
  user_assigned_identity_id              = azurerm_user_assigned_identity.mcp.id
  user_assigned_identity_client_id       = azurerm_user_assigned_identity.mcp.client_id
  user_assigned_identity_principal_id    = azurerm_user_assigned_identity.mcp.principal_id
}



module "func_mcp_api" {
  source                   = "./modules/core/gateway/apim-api/mcp-api"
  api_name                 = module.func_mcp.name
  resource_group_name      = azurerm_resource_group.rg.name
  apim_service_name        = module.apim.APIM_SERVICE_NAME
  mcp_url                  = module.func_mcp.uri
  api_management_id        = module.apim.APIM_ID
  mcp_api_uri_template     = "/runtime/webhooks/mcp"
  api_management_logger_id = module.apim.API_MANAGEMENT_LOGGER_ID
  sampling_percentage      = 100.0
  depends_on               = [module.func_mcp]
}

module "la_mcp_api" {
  source                   = "./modules/core/gateway/apim-api/mcp-api"
  api_name                 = module.la_mcp.logicapp_name
  resource_group_name      = azurerm_resource_group.rg.name
  apim_service_name        = module.apim.APIM_SERVICE_NAME
  mcp_url                  = "https://${module.la_mcp.logicapp_default_hostname}"
  api_management_id        = module.apim.APIM_ID
  mcp_api_uri_template     = "/api/mcpservers/projects/mcp"
  api_management_logger_id = module.apim.API_MANAGEMENT_LOGGER_ID
  sampling_percentage      = 100.0
  depends_on               = [module.la_mcp]
}

module "mcp_product" {
  source              = "./modules/core/gateway/mcp-product"
  product_name        = "MCP"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = module.apim.APIM_SERVICE_NAME
  api_ids             = [module.func_mcp_api.api_id, module.la_mcp_api.api_id]
  oauth_app_id        = azuread_application.oauth_app.client_id
  tenant_id           = data.azuread_client_config.current.tenant_id

}

module "oauth_app" {
  source                   = "./modules/core/gateway/apim-api/oauth-api"
  resource_group_name      = azurerm_resource_group.rg.name
  apim_service_name        = module.apim.APIM_SERVICE_NAME
  tenant_id                = data.azuread_client_config.current.tenant_id
  apim_gateway_url         = module.apim.gateway_url
  api_management_logger_id = module.apim.API_MANAGEMENT_LOGGER_ID
  sampling_percentage      = 100.0
  depends_on               = [module.mcp_product]
}
