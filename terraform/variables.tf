variable "project_name" {
  description = "The base name of the project. Used for resource naming."
  type        = string
  default     = "funcapp"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, test, prod)."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The Azure region to deploy resources to."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
