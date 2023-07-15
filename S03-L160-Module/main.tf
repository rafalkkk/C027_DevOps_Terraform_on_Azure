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

module "rg_and_sa" {
  count           = var.number_of_resources
  source          = "./rg_and_storage_module"
  base_name       = var.base_name
  resource_number = count.index + 1
}

output "rg_name" {
  value = module.rg_and_sa[*].rg_name
}

output "sa_name" {
  value = module.rg_and_sa[*].sa_name
}
