resource "azurerm_storage_account" "storage_account" {
  name                          = var.storage_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var. location
  kind                = "FunctionApp"   # Changed to FunctionApp for Function App
  reserved            = false           # Changed reserved to false for Consumption plan

  sku {
    tier = "Dynamic"    # Changed to Dynamic tier for Consumption plan
    size = "Y1"         # Changed to Y1 size for Consumption plan
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  os_type                    = var.os_type

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = var.functions_worker_runtime  # Corrected the spelling here
  }

  site_config {
    java_version = var.java_version
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
