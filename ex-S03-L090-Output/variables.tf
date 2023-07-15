variable "rg_name" {
  type        = string
  description = "Name of main resource group"
  default     = "App-VM-RG"
}

variable "vm_name" {
  type        = string
  description = "Name of virtual machine"
  default     = "app01"
  validation {
    condition = ! strcontains(lower(var.vm_name), "vm")
    error_message = "Initial name of the virtual machine cannot contain substring 'vm'."
  }
  sensitive = true
}

variable "admin_username" {
  type        = string
  description = "Administrator user name"
  default     = "adminuser"
  validation {
    condition = lower(var.admin_username) == var.admin_username
    error_message = "Admin user name can use only lowercase letters."
  }
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

variable "subnet_name" {
  type        = string
  description = "Subnet name"
  default     = "dev_subnet"
}

variable "app_code" {
  type = string
  description = "Application code"
  default = "hr"
}