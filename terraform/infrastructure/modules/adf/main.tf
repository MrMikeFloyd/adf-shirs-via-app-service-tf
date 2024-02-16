# resource group
resource "azurerm_resource_group" "adf-rg" {
  name     = var.resource-group-name
  location = var.region

  tags = {
    environment = var.env_name
    application = var.application-name
  }
}

# ----------------------- storage resources for test data (blob -> blob) -----------------------
# TODO: Remove and replace with "real" source/dest resources if needed
resource "azurerm_storage_account" "source_storage" {
  name                     = var.source-storageaccount-name
  resource_group_name      = azurerm_resource_group.adf-rg.name
  location                 = azurerm_resource_group.adf-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "dest_storage" {
  name                     = var.dest-storageaccount-name
  resource_group_name      = azurerm_resource_group.adf-rg.name
  location                 = azurerm_resource_group.adf-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ----------------------- Data Factory -----------------------

resource "azurerm_data_factory" "adf-poc-datafactory" {
  name                = var.adf-name
  resource_group_name = azurerm_resource_group.adf-rg.name
  location            = var.region
  # First, build ADF via Designer, then link to repo from ADF
  # Link to Azure DevOps repo. For setup, see
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory.html#vsts_configuration
  # https://learn.microsoft.com/en-us/azure/data-factory/source-control
  # https://medium.com/twodigits/deploy-your-azure-data-factory-through-terraform-2a9c2bd2d75d
  vsts_configuration {
    account_name    = var.ado_org_name
    branch_name     = var.ado_branch_name
    project_name    = var.ado_project_name
    repository_name = var.ado_repo_name
    root_folder     = var.ado_root_folder
    tenant_id       = var.ado_tenant_id
  }
  tags = {
    environment = var.env_name
    application = var.application-name
  }
}

# Define SHIR here
# See also https://techcommunity.microsoft.com/t5/azure-integration-services-blog/automated-secure-infrastructure-for-self-hosted-integration/ba-p/3636883
resource "azurerm_data_factory_integration_runtime_self_hosted" "shir" {
  name            = var.shir-name
  data_factory_id = azurerm_data_factory.adf-poc-datafactory.id
}

output "adf-shir-definition" {
  value = azurerm_data_factory_integration_runtime_self_hosted.shir
}


