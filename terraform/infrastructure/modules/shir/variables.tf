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

variable "acr-name" {
  description = "Name of the Azure Container Registry to pull images from"  
}

variable "acr-id" {
  description = "ID of the Azure Container Registry to pull images from"  
}

variable "adf-authkey" {
  description = "Authentication key to use for registering the SHIR against the desired ADF"
}

variable "app-service-plan-name" {
  description = "Name of the App Service Plan"
}

variable "web-app-name" {
  description = "Name of the App Service Web App"
}
