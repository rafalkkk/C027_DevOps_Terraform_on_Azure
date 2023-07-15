terraform {
   required_providers {
     azurerm = {
       source  = "hashicorp/azurerm"
       version = "=3.60.0"
     }
   }
   required_version = ">= 1.5.2"
 }

 provider "azurerm" {
   features {}
 }

variable "resource_name" {
  type        = string
  description = "Name of all resources"
  default     = "secret827443"
}

variable "resource_location" {
  type        = string
  description = "Location for all resources"
  default     = "eastus"
}


 locals {
   tags = {
     create_date = formatdate("YYYYMMDD", timestamp())
     create_time = formatdate("HH:mm:ss", timestamp())
   }
 }

 resource "azurerm_resource_group" "rg" {
   name     = "rg_${var.resource_name}"
   location = var.resource_location
   tags     = local.tags
 }

 data "azurerm_client_config" "current" {}

 resource "azurerm_key_vault" "kv" {
   name                = "kv${var.resource_name}"
   location            = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name
   sku_name            = "standard"
   tenant_id           = data.azurerm_client_config.current.tenant_id
 }


# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.29.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

# variable "resource_name" {
#   type        = string
#   description = "Name of all resources"
#   default     = "secret827443"
# }

# variable "resource_location" {
#   type        = string
#   description = "Location for all resources"
#   default     = "eastus"
# }


# module "kv" {
#   source   = "./kv"
#   rg_name  = "rg_${var.resource_name}"
#   location = var.resource_location
#   kv_name  = "kv${var.resource_name}"
# }

# output "kv_name" {
#   value = module.kv.kv_name
# }
