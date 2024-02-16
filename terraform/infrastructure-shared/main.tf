terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8" # TODO: Switch back to "~>3.0" once the checksum issue is fixed with 3.9.0
    }
  }

  # Fill with backend data as per remote-state provisioning output
  backend "azurerm" {
    resource_group_name  = "adf-poc-tfstate"
    storage_account_name = "tfstate-<accountname>"
    container_name       = "tfstate"
    key                  = "terraform-infra-shared.tfstate"
  }
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

module "acr" {
  source              = "./modules/acr"
  resource-group-name = "adf-poc-acr"
  region              = "West Europe"
  project             = "My Project"
  application-name    = "ADF PoC"
  env_name            = "dev"
  acr-managed-id-name = "ADF-SHIR"
  build-schedule-cron = "10 12 * * *"
}

output "acr-name" {
  value = module.acr.acr-name
}

output "acr-id" {
  value = module.acr.acr-id
}

