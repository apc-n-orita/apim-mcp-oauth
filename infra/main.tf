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

  logicapp = {
    tags = merge(local.tags, { azd-service-name = "lamcp" })
    runtime = {
      functions_extension_version = "~4"
      powershell_version          = "7.4"
      node_version                = "~22"
      extension_bundle_version    = "[1.*, 2.0.0)"
    }
    app_settings = [
      {
        name  = "OTEL_SERVICE_NAME"
        value = "lamcp"
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
resource "random_uuid" "mcp_invoke_role" {}

resource "azuread_application" "oauth_app" {
  display_name = "mcp-oauth-app-${substr(local.resource_token, 0, 3)}"
  owners       = [data.azuread_client_config.current.object_id]
  #group_membership_claims = ["SecurityGroup"]
  #group_membership_claims = ["ApplicationGroup"]

  #optional_claims {
  #  access_token {
  #    name                  = "groups"
  #    essential             = false
  #    additional_properties = []
  #  }
  #}

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

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Grants access to invoke MCP backends directly (APIM Managed Identity and ops group)"
    display_name         = "Mcp.Invoke"
    enabled              = true
    id                   = random_uuid.mcp_invoke_role.result
    value                = "Mcp.Invoke"
  }

  lifecycle {
    ignore_changes = [
      identifier_uris,
      api,
      web,
    ]
  }
}


resource "azuread_service_principal" "oauth_app_sp" {
  client_id = azuread_application.oauth_app.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Ops group for direct backend access (bypassing APIM), for troubleshooting
resource "azuread_group" "ops_mcp_access" {
  display_name     = "ops-mcp-access-${var.environment_name}"
  security_enabled = true
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_group_member" "ops_mcp_access_current_user" {
  group_object_id  = azuread_group.ops_mcp_access.object_id
  member_object_id = data.azuread_client_config.current.object_id
}


# Assign Mcp.Invoke role to APIM Managed Identity
resource "azuread_app_role_assignment" "apim_mcp_invoke" {
  principal_object_id = module.apim.apim_principal_id
  app_role_id         = azuread_service_principal.oauth_app_sp.app_role_ids["Mcp.Invoke"]
  resource_object_id  = azuread_service_principal.oauth_app_sp.object_id
  depends_on          = [module.apim]
}

# Assign Mcp.Invoke role to ops group
resource "azuread_app_role_assignment" "ops_group_mcp_invoke" {
  principal_object_id = azuread_group.ops_mcp_access.object_id
  app_role_id         = azuread_service_principal.oauth_app_sp.app_role_ids["Mcp.Invoke"]
  resource_object_id  = azuread_service_principal.oauth_app_sp.object_id
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
  local_authentication_disabled = false
}


module "apim" {
  source                                 = "./modules/core/gateway/apim"
  location                               = var.location
  rg_name                                = azurerm_resource_group.rg.name
  tags                                   = local.tags
  sku                                    = local.apim.sku
  skuCount                               = local.apim.skuCount
  name                                   = "${azurecaf_name.apim_name.result}-${substr(local.resource_token, 0, 3)}"
  publisher_email                        = local.apim.publisher_email
  publisher_name                         = local.apim.publisher_name
  application_insights_id                = azurerm_application_insights.ai.id
  application_insights_connection_string = azurerm_application_insights.ai.connection_string
  identity_type                          = "SystemAssigned"
  log_analytics_workspace_id             = azurerm_log_analytics_workspace.law.id
}


resource "azurerm_user_assigned_identity" "mcp" {
  name                = "mcp"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# la_mcp (Logic App) が APPLICATIONINSIGHTS_AUTHENTICATION_STRING (AAD認証) で
# Application Insights にテレメトリを送信するために必要
resource "azurerm_role_assignment" "mcp_monitoring_metrics_publisher" {
  scope                = azurerm_application_insights.ai.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_user_assigned_identity.mcp.principal_id
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
  name         = "la-mcp-${var.environment_name}-${substr(local.resource_token, 0, 3)}"
  location     = var.location
  rg_name      = azurerm_resource_group.rg.name
  rg_id        = azurerm_resource_group.rg.id
  tags         = local.logicapp.tags
  sku_name     = "WS1"
  app_settings = local.logicapp.app_settings

  # Storage account settings
  storage_account_id         = module.la_mcp_storage.storage_account_id
  storage_account_name       = module.la_mcp_storage.name
  storage_account_access_key = module.la_mcp_storage.primary_access_key

  # Runtime settings
  functions_extension_version = local.logicapp.runtime.functions_extension_version
  powershell_version          = local.logicapp.runtime.powershell_version
  node_version                = local.logicapp.runtime.node_version
  extension_bundle_version    = local.logicapp.runtime.extension_bundle_version

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



module "la_mcp_api" {
  source                   = "./modules/core/gateway/apim-api/mcp-api"
  api_name                 = module.la_mcp.logicapp_name
  api_description          = "Hello MCP server hosted on Azure Logic Apps"
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
  api_ids             = [module.la_mcp_api.api_id]
  oauth_app_id        = azuread_application.oauth_app.client_id
  tenant_id           = data.azuread_client_config.current.tenant_id

}

# MCPサーバー共通の OAuth 2.0 Protected Resource Metadata (RFC 9728) 動的ディスカバリーAPI。
# このAPI自体は path=/.well-known/oauth-protected-resource に固定し、
# MCPサーバーごとのオペレーション (下記 mcp_prm_* モジュール) をその配下に追加する。
module "oauth_app" {
  source                   = "./modules/core/gateway/apim-api/oauth-api"
  resource_group_name      = azurerm_resource_group.rg.name
  apim_service_name        = module.apim.APIM_SERVICE_NAME
  api_management_logger_id = module.apim.API_MANAGEMENT_LOGGER_ID
  sampling_percentage      = 100.0
  depends_on               = [module.mcp_product]
}

# lamcp (apim-mcp-oauth 共有 Entra ID アプリのuser_impersonationスコープ) 向けのPRMオペレーション
module "mcp_prm_lamcp" {
  source              = "./modules/core/gateway/apim-api/mcp-prm-operation"
  resource_group_name = azurerm_resource_group.rg.name
  apim_service_name   = module.apim.APIM_SERVICE_NAME
  prm_api_name        = module.oauth_app.api_name
  mcp_server_id       = "lamcp"
  mcp_endpoint_path   = "${module.la_mcp_api.api_name}${module.la_mcp_api.api_uri_template}"
  apim_gateway_url    = module.apim.gateway_url
  scope               = "api://${azuread_application.oauth_app.client_id}/user_impersonation"
}
