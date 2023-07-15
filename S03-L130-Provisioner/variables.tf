variable "rg_name" {
  type        = string
  description = "Name of the main resource group"
  default     = "HelloTerraform_RG"
}

variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
  default     = "ws"
}

variable "number_of_vm" {
  type        = number
  description = "Number of VM to create"
  default     = 1
}


variable "vnet_name" {
  type        = string
  description = "Name of VNET"
  default     = "Terraform_VNET"
}

variable "firewall_rules" {
  type        = map(any)
  description = "Firewal exceptions"
  default = {
    SSH = {
      name                   = "SSH",
      priority               = "300",
      destination_port_range = 22
    },
    HTTPS = {
      name                   = "HTTPS",
      priority               = "400",
      destination_port_range = 443
    },
    IMAP_SSL = {
      name                   = "IMAP_SSL",
      priority               = "500",
      destination_port_range = 993
    }
  }
}

variable "enable_password_authentication" {
  type        = bool
  description = "Is password authentication enabled?"
  default     = false
}

variable "subnet_name" {
  type        = string
  description = "Subnet where the VM should be attached"
  default     = "dev_subnet"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources"
  default     = "Home"
}

variable "env" {
  type        = string
  description = "Environment"
  default     = "dev"
}

