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

data "azurerm_application_insights" "appinsights" {
  name                = var.application_insights_name
  resource_group_name = var.rg_name
}
# ------------------------------------------------------------------------------------------------------
# Deploy api management service
# ------------------------------------------------------------------------------------------------------

# Create a new APIM instance
resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  tags                = var.tags
  sku_name            = "${var.sku}_${(var.sku == "Consumption") ? 0 : ((var.sku == "Developer") ? 1 : var.skuCount)}"

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "SystemAssigned, UserAssigned" ? [var.azurerm_user_assigned_identity_id] : null
  }
}

# Create Logger
resource "azapi_resource" "apim_logger" {
  type      = "Microsoft.ApiManagement/service/loggers@2022-08-01"
  name      = "app-insights-logger"
  parent_id = azurerm_api_management.apim.id

  body = {
    properties = {
      loggerType  = "applicationInsights"
      description = "Application Insights logger with system-assigned managed identity"
      credentials = {
        connectionString = data.azurerm_application_insights.appinsights.connection_string
        identityClientId = "systemAssigned"
      }
    }
  }
}

resource "azurerm_role_assignment" "monitoring_metrics_publisher" {
  scope                = data.azurerm_application_insights.appinsights.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_api_management.apim.identity[0].principal_id
}

resource "azurerm_monitor_diagnostic_setting" "apim_logger" {
  name                           = "send-to-law"
  target_resource_id             = azurerm_api_management.apim.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

#resource "azurerm_api_management_policy" "apim" {
#  api_management_id = azurerm_api_management.apim.id
#  xml_content = templatefile("${path.module}/files/policy/all_api.xml",
#    {
#      origin_dev_url = azurerm_api_management.apim.developer_portal_url
#    }
#  )
#}

resource "azurerm_api_management_diagnostic" "all-api" {
  identifier                = "applicationinsights"
  api_management_name       = azurerm_api_management.apim.name
  resource_group_name       = var.rg_name
  api_management_logger_id  = azapi_resource.apim_logger.id
  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes     = 0
    headers_to_log = []
  }

  frontend_response {
    body_bytes     = 0
    headers_to_log = []
  }

  backend_request {
    body_bytes     = 0
    headers_to_log = []
  }

  backend_response {
    body_bytes     = 0
    headers_to_log = []
  }
}
