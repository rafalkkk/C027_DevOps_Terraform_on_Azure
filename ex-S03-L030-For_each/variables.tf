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

variable "vm_name" {
  type        = string
  description = "Name of virtual machine"
  default     = "app01vm"
}

variable "admin_username" {
  type        = string
  description = "Administrator user name"
  default     = "adminuser"
}

variable "admin_password" {
  type        = string
  description = "Administrator's password"
  default     = "TheAnswerIs42."
}

variable "disks" {
  type        = map(any)
  description = "Managed disks specifications"
  default = {
    disk_data = {
      lun   = "10",
      cache = "ReadWrite",
      size  = 1
    },
    disk_log = {
      lun   = "11",
      cache = "None",
      size  = 1
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
