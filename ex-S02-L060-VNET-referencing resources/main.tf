# Provider block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "app_data_rg" {
  name     = "App-Data-RG"
  location = "West Europe"
}

resource "azurerm_storage_account" "app_data_storage" {
  name                     = "appdatasa92742894"
  resource_group_name      = azurerm_resource_group.app_data_rg.name
  location                 = azurerm_resource_group.app_data_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}