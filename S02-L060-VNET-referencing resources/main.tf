# Provider block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "main_rg" {
  name     = "HelloTerraform_RG"
  location = "East US"
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = "Terraform_VNET"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = ["10.1.0.0/16"]

  subnet {
    name           = "dev_subnet"
    address_prefix = "10.1.1.0/24"
  }

  subnet {
    name           = "tst_subnet"
    address_prefix = "10.1.2.0/24"
  }

}

