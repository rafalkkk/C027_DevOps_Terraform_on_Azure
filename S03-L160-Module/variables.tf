variable "base_name" {
  type        = string
  description = "Base name for resources"
  default     = "stoacc"
}

variable "number_of_resources" {
  type        = number
  description = "Number of resources to create"
  default     = 4
}
