# Provider block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "tfstate"
  #   storage_account_name = "tfstate1282673370"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "rg_name" {
  type        = string
  description = "Name of the main resource group"
  default     = "TestImport"
}

variable "location" {
  type        = string
  description = "Location for resources"
  default     = "eastus"
}

resource "azurerm_resource_group" "main_rg" {
  name = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "main_vnet" {
    address_space           = [
        "10.0.0.0/16",
    ]
    dns_servers             = []
    location                =  azurerm_resource_group.main_rg.location
    name                    = "test-vnet"
    resource_group_name     = azurerm_resource_group.main_rg.name
    tags                    = {}

    timeouts {}
}

resource "azurerm_subnet" "default_subnet" {
    address_prefixes                               = [
        "10.0.0.0/24",
    ]
    enforce_private_link_endpoint_network_policies = true
    enforce_private_link_service_network_policies  = false
    name                                           = "default"
    resource_group_name                            = azurerm_resource_group.main_rg.name
    service_endpoints                              = []
    virtual_network_name                           = azurerm_virtual_network.main_vnet.name

    timeouts {}
}
