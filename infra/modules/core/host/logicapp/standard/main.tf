terraform {
  required_providers {
    azurerm = {
      version = "~>4.58.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.0.0"
    }
  }
}


resource "azurerm_storage_share" "logicapp_share" {
  name               = "sharename"
  storage_account_id = var.storage_account_id
  quota              = 50
}

# Creates a App Service Plan for hosting Logic Apps
resource "azurerm_service_plan" "logicapp_plan" {
  name                = "plan-${var.name}"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Windows"
  sku_name            = var.sku_name
}

# Logic App Standard (using azapi_resource for full control)
resource "azapi_resource" "logicapp" {
  type      = "Microsoft.Web/sites@2023-12-01"
  name      = var.name
  location  = var.location
  tags      = var.tags
  parent_id = var.rg_id
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      var.user_assigned_identity_id
    ]
  }

  body = {
    kind = "functionapp,workflowapp"
    properties = {
      serverFarmId        = replace(azurerm_service_plan.logicapp_plan.id, "serverFarms", "serverfarms")
      httpsOnly           = true
      publicNetworkAccess = "Enabled"
      siteConfig = {
        appSettings = concat(
          [
            # AzureWebJobsStorage - Blob/Queue/Table 用のマネージドID認証
            { name = "AzureWebJobsStorage__blobServiceUri", value = "https://${var.storage_account_name}.blob.core.windows.net/" },
            { name = "AzureWebJobsStorage__queueServiceUri", value = "https://${var.storage_account_name}.queue.core.windows.net/" },
            { name = "AzureWebJobsStorage__tableServiceUri", value = "https://${var.storage_account_name}.table.core.windows.net/" },
            { name = "AzureWebJobsStorage__credential", value = "managedidentity" },
            { name = "AzureWebJobsStorage__managedIdentityResourceId", value = var.user_assigned_identity_id },

            # Azure Files - ストレージ接続 (マネージドID非対応のため接続文字列が必須)
            { name = "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING", value = "DefaultEndpointsProtocol=https;AccountName=${var.storage_account_name};AccountKey=${var.storage_account_access_key};EndpointSuffix=core.windows.net" },
            { name = "WEBSITE_CONTENTSHARE", value = azurerm_storage_share.logicapp_share.name },

            # Application Insights
            { name = "APPLICATIONINSIGHTS_CONNECTION_STRING", value = var.application_insights_connection_string },
            { name = "APPLICATIONINSIGHTS_AUTHENTICATION_STRING", value = "ClientId=${var.user_assigned_identity_client_id};Authorization=AAD" },

            # Logic App 種別
            { name = "APP_KIND", value = "workflowApp" },

            # Extension Bundle 設定
            { name = "AzureFunctionsJobHost__extensionBundle__id", value = "Microsoft.Azure.Functions.ExtensionBundle.Workflows" },
            { name = "AzureFunctionsJobHost__extensionBundle__version", value = var.extension_bundle_version },

            # MCP Server Endpoints 設定
            { name = "AzureFunctionsJobHost__extensions__workflow__McpServerEndpoints__enable", value = "true" },


            # Functions Runtime
            { name = "FUNCTIONS_EXTENSION_VERSION", value = var.functions_extension_version },
            { name = "FUNCTIONS_INPROC_NET8_ENABLED", value = "1" },
            { name = "FUNCTIONS_WORKER_RUNTIME", value = "dotnet" },
            { name = "LOGIC_APPS_POWERSHELL_VERSION", value = var.powershell_version },
            { name = "WEBSITE_NODE_DEFAULT_VERSION", value = var.node_version },
            { name = "WEBSITE_AUTH_AAD_ALLOWED_TENANTS", value = var.tenant_id },

            # OpenTelemetry 設定
            { name = "OTEL_SERVICE_NAME", value = "logic-app-mcp" },
            { name = "AzureFunctionsJobHost__telemetryMode", value = "OpenTelemetry" },
            { name = "AzureFunctionsJobHost__logging__applicationInsights__samplingSettings__isEnabled", value = "false" },
          ],
        )
      }
    }
  }

  response_export_values = ["properties.defaultHostName", "properties.outboundIpAddresses", "identity.principalId"]
}


resource "azurerm_role_assignment" "uai_storage_blob_data_owner" {
  scope                = var.storage_account_id # ストレージアカウントのスコープに変更
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.user_assigned_identity_principal_id
}

resource "azurerm_role_assignment" "uai_storage_account_contributor" {
  scope                = var.storage_account_id # ストレージアカウントのスコープに変更
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.user_assigned_identity_principal_id
}

resource "azurerm_role_assignment" "uai_storage_table_data_contributor" {
  scope                = var.storage_account_id # ストレージアカウントのスコープに変更
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = var.user_assigned_identity_principal_id
}

resource "azurerm_role_assignment" "uai_storage_queue_data_contributor" {
  scope                = var.storage_account_id # ストレージアカウントのスコープに変更
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.user_assigned_identity_principal_id
}


resource "azapi_update_resource" "logicapp_auth" {
  type        = "Microsoft.Web/sites/config@2023-12-01"
  resource_id = "${azapi_resource.logicapp.id}/config/authsettingsV2"

  body = {
    properties = {
      clearInboundClaimsMapping = "false"
      platform = {
        enabled        = true
        runtimeVersion = "~1"
      }

      globalValidation = {
        requireAuthentication       = true
        unauthenticatedClientAction = "Return403"
        excludedPaths               = []
      }

      httpSettings = {
        requireHttps = true
        forwardProxy = {
          convention = "NoProxy"
        }
        routes = {
          apiPrefix = "/.auth"
        }
      }

      identityProviders = {
        azureActiveDirectory = {
          enabled = true
          registration = {
            clientId     = var.azuread_application_entra_app_client_id
            openIdIssuer = "https://login.microsoftonline.com/${var.tenant_id}/v2.0"
          }
          login = {
            disableWWWAuthenticate = false
            loginParameters = [
              "scope=api://${var.azuread_application_entra_app_client_id}/user_impersonation offline_access openid profile User.Read"
            ]
          }
          validation = {
            allowedAudiences = [
              "api://${var.azuread_application_entra_app_client_id}/"
            ]
            defaultAuthorizationPolicy = {
              allowedPrincipals = {
                identities = [var.apim_principal_id]
              }
            }
            jwtClaimChecks = {}
          }
        }
      }

      login = {
        allowedExternalRedirectUrls = []
        cookieExpiration = {
          convention       = "FixedTime"
          timeToExpiration = "08:00:00"
        }
        nonce = {
          nonceExpirationInterval = "00:05:00"
          validateNonce           = true
        }
        preserveUrlFragmentsForLogins = false
        routes                        = {}
        tokenStore = {
          azureBlobStorage           = {}
          enabled                    = false
          fileSystem                 = {}
          tokenRefreshExtensionHours = 72.0
        }
      }
    }
  }
}

