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

variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
  default     = "dev01vm"
}

variable "enable_password_authentication" {
  type        = bool
  description = "Is password authentication enabled?"
  default     = false
}
