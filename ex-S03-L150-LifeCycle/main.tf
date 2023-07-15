# # ------------------------------- Initial status -------------------------------------------
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.60.0"
#     }
#   }
#   required_version = ">= 1.5.2"
# }

# provider "azurerm" {
#   features {}
# }

# variable "rg_name" {
#   default = "RG_Fundamentals"
# }

# locals {
#   tags = {
#     create_date = formatdate("YYYYMMDD", timestamp())
#     create_time = formatdate("HH:mm:ss", timestamp())
#   }
# }

# resource "azurerm_resource_group" "rg" {
#   name     = var.rg_name
#   location = "East US"
#   tags     = local.tags
# }

# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault" "kv" {
#   name                = "kv-kkaakkrriirr"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name            = "standard"
#   tenant_id           = data.azurerm_client_config.current.tenant_id
# }




# ------------------------------------ SOLUTION ------------------------------------------
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

variable "rg_name" {
  default = "RG_Fundamentals"
}

resource "random_id" "random_value" {
  byte_length = 8
  keepers = {
    "sa" = var.rg_name
  }
}

locals {
  tags = {
    create_date = formatdate("YYYYMMDD", timestamp())
    create_time = formatdate("HH:mm:ss", timestamp())
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = "East US"
  tags     = local.tags
  lifecycle {
    ignore_changes  = [tags]
    prevent_destroy = true
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = "kv-${random_id.random_value.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}
