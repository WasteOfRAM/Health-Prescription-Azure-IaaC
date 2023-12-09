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
  location = var.resource_location
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

  app_settings = {
    ConnectionStrings__DefaultConnection = "Server=${azurerm_postgresql_flexible_server.postgresql_server.fqdn};Database=${azurerm_postgresql_flexible_server_database.DB.name};Port=5432;User Id=${azurerm_postgresql_flexible_server.postgresql_server.administrator_login};Password=${azurerm_postgresql_flexible_server.postgresql_server.administrator_password};Ssl Mode=Require;"
    Jwt__Key                             = var.jwt_key
    Jwt__Issuer                          = var.jwt_issuer
    Jwt__Audience                        = var.jwt_audience
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
  sku_name               = "B_Standard_B1ms"
  zone                   = 1
}

resource "azurerm_postgresql_flexible_server_database" "DB" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgresql_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_app_service_connection" "App_DB_connection" {
  name               = "DB_Connection"
  app_service_id     = azurerm_linux_web_app.web_app.id
  target_resource_id = azurerm_postgresql_flexible_server_database.DB.id
  client_type        = "dotnet"

  authentication {
    type   = "secret"
    name   = azurerm_postgresql_flexible_server.postgresql_server.administrator_login
    secret = azurerm_postgresql_flexible_server.postgresql_server.administrator_password
  }
}