# Generate a random string to ensure unique globally required names
resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}



# --- Core Infrastructure ---

# Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = "${var.project_name}${var.environment}${random_string.unique.result}sa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Application Insights (Recommended for monitoring)
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.project_name}-${var.environment}-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  tags                = var.tags
}

# Restored to strictly Y1 (Consumption) to fulfill free-tier constraints.
resource "azurerm_service_plan" "asp" {
  name                = "${var.project_name}-${var.environment}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "Y1"
  tags                = var.tags
}

# Azure Windows Function App
resource "azurerm_windows_function_app" "function" {
  name                       = "${var.project_name}-${var.environment}-${random_string.unique.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  site_config {
    application_insights_key               = azurerm_application_insights.appinsights.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.appinsights.connection_string

    application_stack {
      dotnet_version = "v10.0"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
  }

  tags = var.tags
}



output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "function_app_name" {
  value = azurerm_windows_function_app.function.name
}

output "function_app_default_hostname" {
  value = azurerm_windows_function_app.function.default_hostname
}
