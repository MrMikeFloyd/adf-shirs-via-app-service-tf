variable "application-name" {
  description = "Application associated with the resources"
}

variable "adf-name" {
  description = "Application associated with the resources"
}

variable "shir-name" {
  description = "Name of the self-hosted integration runtime to register with this ADF"
}

variable "resource-group-name" {
  description = "Resource group associated with the resources"
}

variable "source-storageaccount-name" {
  description = "source storage account associated with the resources"
}

variable "dest-storageaccount-name" {
  description = "destination storage account associated with the resources"
}

variable "project" {
  description = "Project associated with the resources"
}

variable "region" {
  description = "The region to deploy the resources to"
}

variable "env_name" {
  description = "Name of the environment"
}

variable "ado_org_name" {
  description = "Azure DevOps Organization name"
}

variable "ado_project_name" {
  description = "Azure DevOps Project name (might contain '%' chars, see repo URL)"
}

variable "ado_repo_name" {
  description = "Azure DevOps Repo name"
}

variable "ado_branch_name" {
  description = "Azure DevOps branch name"
}

variable "ado_root_folder" {
  description = "Azure DevOps Repo root folder"
}

variable "ado_tenant_id" {
  description = "Tenant ID, can be taken from azurerm client config"
}
