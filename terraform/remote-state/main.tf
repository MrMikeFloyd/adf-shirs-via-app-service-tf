# ----------------------------------------------------------
# Remote backend with encryption at rest
# Set up according to https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform
# Make sure that this is provisioned before all ADF resources
# NOT READY FOR PRODUCTION USE (use private endpoint etc. for connecting)
# ----------------------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = var.resource-group-name
  location = var.region
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "${var.storage-account-name}${random_string.resource_code.result}"
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = var.env_name
    application = var.application-name
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.storage-account-name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Output values required in the ADF stack's backend section

output "remote_state_resource_group_name" {
  value = azurerm_resource_group.tfstate.name
}

output "remote_state_storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "remote_state_storage_container_name" {
  value = azurerm_storage_container.tfstate.name
}
