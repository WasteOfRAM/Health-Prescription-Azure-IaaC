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
  name                = "Health_Prescription"
  resource_group_name = azurerm_resource_group.HPA_RG.name
  location            = azurerm_resource_group.HPA_RG.location
  service_plan_id     = azurerm_service_plan.linux_service_plan.id
  
  
  site_config {
    application_stack {
      dotnet_version = 8.0
    }
  }
}