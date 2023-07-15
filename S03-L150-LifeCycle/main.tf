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

# variable "sa_base_name" {
#   default = "sahome"
# }

# resource "random_id" "sa_suffix" {
#   byte_length = 8
#   keepers = {
#     "sa" = var.sa_base_name
#   }
# }

# resource "azurerm_resource_group" "my_rg" {
#   location = "East US"
#   name     = "Dont_delete_RG"
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "azurerm_storage_account" "my_sa" {
#   account_replication_type = "LRS"
#   account_tier             = "Standard"
#   location                 = "East US"
#   name                     = "${var.sa_base_name}${lower(random_id.sa_suffix.hex)}"
#   resource_group_name      = "Dont_delete_RG"
#   access_tier              = "Cool"
#   depends_on               = [azurerm_resource_group.my_rg]
#   lifecycle {
#     ignore_changes = [access_tier]
#   }
# }






