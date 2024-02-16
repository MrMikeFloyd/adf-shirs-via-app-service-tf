terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0" # TODO: Switch back to "~>3.0" once the checksum issue is fixed with 3.9.0
    }
  }

  # Fill with backend data as per remote-state provisioning output
  backend "azurerm" {
    resource_group_name  = "poc-tfstate"
    storage_account_name = "FILL ME"
    container_name       = "tfstate"
    key                  = "terraform-infra.tfstate"
  }
}

locals {
  # Retrieve values from infra shared stack outputs
  acr-name = "FILL ME (container registry name)"
  acr-id = "FILL ME (resource id)"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

module "adf" {
  source                     = "./modules/adf"
  resource-group-name        = "adf-poc"
  region                     = "West Europe"
  application-name           = "ADF PoC"
  project                    = "My Project"
  env_name                   = "dev"
  adf-name                   = "adf-poc"
  shir-name                  = "adf-shir"
  source-storageaccount-name = "adfpocstoragesource${random_string.resource_code.result}"
  dest-storageaccount-name   = "adfpocstoragedest${random_string.resource_code.result}"
  ado_org_name               = "your-org"
  ado_branch_name            = "main"
  ado_project_name           = "My Project"
  ado_repo_name              = "ADF-PoC-DataFactory"
  ado_root_folder            = "/"
  ado_tenant_id              = data.azurerm_client_config.current.tenant_id
}

module "shir" {
  source                = "./modules/shir"
  resource-group-name   = "adf-poc-shir"
  region                = "West Europe"
  application-name      = "ADF PoC"
  project               = "My Project"
  env_name              = "dev"
  acr-name              = local.acr-name
  acr-id                = local.acr-id
  adf-authkey           = module.adf.adf-shir-definition.primary_authorization_key # TODO: Check if this works
  app-service-plan-name = "adf-shirs-${random_string.resource_code.result}"
  web-app-name          = "adf-shirs-${random_string.resource_code.result}"
}
