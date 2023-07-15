variable "rg_name" {
  type        = string
  description = "Name of the main resource group"
  default     = "HelloTerraform_RG"
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

variable "subnet_name" {
  type        = string
  description = "Subnet where the VM should be attached"
  default     = "dev_subnet"
}
