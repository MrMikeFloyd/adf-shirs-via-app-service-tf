variable "application-name" {
  description = "Application associated with the resources"
  default     = "ADF PoC"
}

variable "project" {
  description = "Project associated with the resources"
  default     = "My Project"
}

variable "resource-group-name" {
  description = "The name of the storage resources for storing the remote state"
  default     = "adf-poc-tfstate"
}

variable "storage-account-name" {
  description = "The name of the storage account for storing the remote state"
  default     = "tfstate"
}

variable "region" {
  description = "The region to deploy the resources to"
  default     = "West Europe"
}

variable "env_name" {
  description = "Name of the environment"
  default     = "dev"
}
