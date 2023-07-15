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
