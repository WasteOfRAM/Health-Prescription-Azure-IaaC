terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.83.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "TerraformState"
    storage_account_name = "terraformfilesstorage"
    container_name       = "statefiles"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "HPA_RG" {
  name     = "${env.RESOURCE_GROUP_NAME}"
  location = "West Europe"
}