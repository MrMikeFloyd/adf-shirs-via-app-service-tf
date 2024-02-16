variable "application-name" {
  description = "Application associated with the resources"
}

variable "project" {
  description = "Project associated with the resources"
}

variable "region" {
  description = "The region to deploy the resources to"
}

variable "resource-group-name" {
  description = "Resource group associated with the resources"
}

variable "env_name" {
  description = "Name of the environment"
}

variable "acr-managed-id-name" {
  description = "Name of the associated ACR managed id"
}

variable "build-schedule-cron" {
  description = "Cron expression for time-based build scheduling"
}
