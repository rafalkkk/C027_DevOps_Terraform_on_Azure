variable "rg_name" {
  type        = string
  description = "Name of the main resource group"
  default     = "HelloTerraform_RG"
}

variable "location" {
  type        = string
  description = "Location (region) for resources"
  default     = "East US"
}

variable "vnet_address_space" {
  type        = string
  description = "Address space for VNET"
  default     = "10.1.0.0/16"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default = {
    "environment" = "DEV",
    "project"     = "NewDevHome",
    "team"        = "Software House"
  }
}

variable "subnets" {
  type        = map(any)
  description = "Subnets information"
  default = {
    dev_subnet = {
      address = ["10.1.1.0/24"]
    },
    tst_subnet = {
      address = ["10.1.2.0/24"]
    },
    uat_subnet = {
      address = ["10.1.3.0/24"]
    },
    prd_subnet = {
      address = ["10.1.4.0/24"]
    }
  }
}
