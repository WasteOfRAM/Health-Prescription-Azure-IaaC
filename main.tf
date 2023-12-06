terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.83.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "terraformfilesstorage"
    container_name       = "statefiles"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "HPA_RG" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_service_plan" "linux_service_plan" {
  name                = var.free_web_app_plan
  resource_group_name = azurerm_resource_group.HPA_RG.name
  location            = azurerm_resource_group.HPA_RG.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.HPA_RG.name
  location            = azurerm_resource_group.HPA_RG.location
  service_plan_id     = azurerm_service_plan.linux_service_plan.id
  
  
  site_config {
    always_on = false

    application_stack {
      dotnet_version = "8.0"
    }
  }
}

resource "azurerm_postgresql_flexible_server" "postgresql_server" {
  name                   = var.db_server_name
  resource_group_name    = azurerm_resource_group.HPA_RG.name
  location               = azurerm_resource_group.HPA_RG.location
  version                = "16"
  administrator_login    = var.db_admin_login
  administrator_password = var.db_admin_pass
  storage_mb             = 32768
  sku_name               = "Standard_B1ms"
}

resource "azurerm_postgresql_flexible_server_database" "example" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgresql_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}