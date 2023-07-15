terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main_rg" {
  name     = "VNET_Dynamic_RG"
  location = "East US"
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = "Dynamic_VNET"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = ["10.1.0.0/16"]

  # subnet {
  #   name           = "dev_subnet"
  #   address_prefix = "10.1.1.0/24"
  # }

  # subnet {
  #   name           = "tst_subnet"
  #   address_prefix = "10.1.2.0/24"
  # }

  # subnet {
  #   name           = "uat_subnet"
  #   address_prefix = "10.1.3.0/24"
  # }

  # subnet {
  #   name           = "prd_subnet"
  #   address_prefix = "10.1.4.0/24"
  # }

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
    }
  }

}


variable "subnets" {
  type        = list(any)
  description = "Subnets definition"
  default = [
    {
      name           = "dev_subnet",
      address_prefix = "10.1.1.0/24"
    },
    {
      name           = "tst_subnet",
      address_prefix = "10.1.2.0/24"
    },
    {
      name           = "uat_subnet",
      address_prefix = "10.1.3.0/24"
    },
    {
      name           = "prd_subnet",
      address_prefix = "10.1.4.0/24"
    }
  ]
}

