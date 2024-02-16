locals {
  shir-container-version = "adf/shir:latest"
}

# resource group
resource "azurerm_resource_group" "adf-rg" {
  name     = var.resource-group-name
  location = var.region

  tags = {
    environment = var.env_name
    application = var.application-name
  }
}

# ----------------------- Container Registry and Task -----------------------

# TODO: Clarify: Private access needed? these are public images, can probably stay public
resource "azurerm_container_registry" "acr" {
  name                = "acrshir139828d93" # TODO: must be globally unique, best add random sequence
  resource_group_name = azurerm_resource_group.adf-rg.name
  location            = azurerm_resource_group.adf-rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_container_registry_task" "acr-task" {
  name                  = "buildShirImage"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os           = "Windows"
    architecture = "amd64"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/Azure/Azure-Data-Factory-Integration-Runtime-in-Windows-Container.git"
    context_access_token = "abc-def-ghi" # TODO: Clarify: Not sure how to get around this - this is a public repo
    image_names          = ["${local.shir-container-version}"]
  }
  timer_trigger {
    name = "build_daily"
    # cron time refers to utc
    schedule = var.build-schedule-cron
  }
}

output "acr-name" {
  value = azurerm_container_registry.acr.name
}

output "acr-id" {
  value = azurerm_container_registry.acr.id
}