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
    client_id            = "${AZURE_CLIENT_ID}"
    client_secret        = "${AZURE_CLIENT_SECRET}"
    subscription_id      = "${AZURE_CLIENT_SUBSCRIPTION_ID}"
    tenant_id            = "${AZURE_TENANT_ID}"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "HPA_RG" {
  name     = "${env.RESOURCE_GROUP_NAME}"
  location = "West Europe"
}