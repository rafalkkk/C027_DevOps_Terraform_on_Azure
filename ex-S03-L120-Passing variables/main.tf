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

variable "rg_name" {
  type        = string
  description = "Name of Resource Group"
  nullable    = false
  default     = "RG_001"
}

variable "location" {
  type        = string
  description = "Location (region)"
  nullable    = false
  default     = "East US"
}

variable "vnet_name" {
  type        = string
  description = "Name of VNET"
  nullable    = false
  default     = "VNET_001"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNET address space"
  nullable    = false
  default     = ["10.1.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "Name of subnet"
  nullable    = false
  default     = "subnet_001"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address prefix for subnet"
  nullable    = false
  default     = "10.1.1.0/24"
}

resource "azurerm_resource_group" "main_rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = var.vnet_address_space

  subnet {
    name           = var.subnet_name
    address_prefix = var.subnet_address_prefix
  }
}
