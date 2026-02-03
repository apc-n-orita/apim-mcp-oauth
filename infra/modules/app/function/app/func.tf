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
    random = {
      source  = "hashicorp/random"
      version = "~>3.7.0"
    }

  }
}



# Random suffix for ensuring uniqueness of Blob container name
resource "random_string" "container_suffix" {
  length  = 7
  upper   = false
  special = false
}

# Create Blob container for Function App
resource "azurerm_storage_container" "function_blob_container" {
  name                  = "app-package-${var.name}-${random_string.container_suffix.result}"
  storage_account_id    = var.function_storage_id
  container_access_type = "private"
}

resource "azapi_resource" "function" {
  type      = "Microsoft.Web/sites@2023-12-01"
  name      = var.name
  location  = var.location
  parent_id = var.rg_id
  tags      = var.tags

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      var.identity_id
    ]
  }
  body = {
    kind = var.kind
    properties = {
      serverFarmId = replace(var.app_service_plan_id, "serverFarms", "serverfarms")
      functionAppConfig = {
        deployment = {
          storage = {
            type  = "blobcontainer"
            value = "${var.primary_blob_endpoint}${azurerm_storage_container.function_blob_container.name}"
            authentication = {
              type                           = "userassignedidentity"
              userAssignedIdentityResourceId = var.identity_id
            }
          }
        }
        scaleAndConcurrency = {
          instanceMemoryMB     = var.instance_memory_mb
          maximumInstanceCount = var.maximum_instance_count
        }
        runtime = {
          name    = var.runtime_name
          version = var.runtime_version
        }
      }
      siteConfig = {
        appSettings = distinct(
          concat(
            [
              {
                name  = "AzureWebJobsStorage__accountName"
                value = var.storage_account_name
              },
              {
                name  = "AzureWebJobsStorage__credential"
                value = "managedidentity"
              },
              {
                name  = "AzureWebJobsStorage__clientId"
                value = var.identity_client_id
              },
              {
                name  = "APPLICATIONINSIGHTS_AUTHENTICATION_STRING"
                value = "ClientId=${var.identity_client_id};Authorization=AAD"
              },
              {
                name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
                value = var.application_insights_connection_string
              }
            ],
            var.app_settings
          )
        )
      }
      #virtualNetworkSubnetId = var.virtual_network_subnet_id != "" ? var.virtual_network_subnet_id : null
    }
  }

  response_export_values = [
    "properties.defaultHostName",
    "properties.internalId",
    "identity.principalId"
  ]

  lifecycle {
    ignore_changes = [
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }

}


resource "time_sleep" "wait_function" {
  depends_on = [
    azapi_resource.function
  ]
  create_duration = "60s"
}


# For obtaining Function App host key (masterKey)
# resource "azapi_resource_action" "functionapp_host_keys" {
#   type                   = "Microsoft.Web/sites@2023-12-01"
#   resource_id            = azapi_resource.function.id
#   action                 = "host/default/listkeys"
#   method                 = "POST"
#   response_export_values = ["*"]
#   depends_on = [
#     azapi_resource.function,
#     time_sleep.wait_function,
#   ]
# }

resource "azapi_update_resource" "func_auth" {
  type        = "Microsoft.Web/sites/config@2023-12-01"
  resource_id = "${azapi_resource.function.id}/config/authsettingsV2"

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


