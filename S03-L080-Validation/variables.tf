variable "rg_name" {
  type        = string
  description = "Name of the main resource group"
  default     = "HelloTerraform_RG"
  validation {
    condition     = endswith(upper(var.rg_name), "RG")
    error_message = "Resource Group name must end with RG."
  }
}

variable "location" {
  type        = string
  description = "Location (region) for resources"
  default     = "East US"
  validation {
    condition     = contains(["east us", "west europe", "australia east"], lower(var.location))
    error_message = "Location must be one of following: east us, west europe, australia east"
  }
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNET"
  default     = "Terraform_VNET"
  validation {
    condition     = length(var.vnet_name) > 6 && endswith(upper(var.vnet_name), "VNET")
    error_message = "VNET name must be longer than 6 characters and must end with VNET."
  }
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
