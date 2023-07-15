variable "rg_name" {
  type        = string
  description = "Name of main resource group"
  default     = "App-VM-RG"
}

variable "location" {
  type        = string
  description = "Location of reosurces"
  default     = "East US"
}

variable "vnet_addressspace" {
  type        = string
  description = "Address sapace assigned to VNET"
  default     = "10.1.0.0/16"
}

variable "subnets" {
  type        = map(any)
  description = "Subnets' definition"
  default = {

    dev_subnet = {
      address_prefix = ["10.1.1.0/24"]
    },
    tst_subnet = {
      address_prefix = ["10.1.2.0/24"]
    }
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default = {
    "Owner"        = "Rafal"
    "Organization" = "Mobilo"
    "Environment"  = "Development"
  }
}
