locals {
  acr-url                = "https://${var.acr-name}.azurecr.io"
  shir-container-name    = "adf/shir"
  shir-container-version = "latest"
  appservice-nodename    = "AppService-SHIR"
  # TODO: Need P2v3???
  appservice-skuname     = "P1v2" # Allowed by Policy 'onecloud_governance_allowed-app-service-plan-sizes-for-dev':["F1","D1","B1","B2","S1","S2","P1v2","P0v3","I1","I1v2","Y1"]
  irNodeRemoteAccessPort = "8060"
  irNodeExpirationTime   = "600"
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

# ----------------------- SHIR VNet/Subnet -----------------------

# TODO: FIX: Data Factory connection to SHIR. SHIR shows up in ADF screen, but flagged as unavailable. SHIR seems to be running ok. 
# Fix: Create SHIR VNet/Subnet and add it?
# Yes. See https://github.com/Azure-Samples/azure-data-factory-runtime-app-service
# You need VNets and connect the SHIR to ADF via a private endpoint  -check again that it is setup exactly like the MS Bicep sample
#data "azurerm_subnet" "shir_subnet" { # TODO: is this really needed for connecting the SHIR to the ADF?
#  name                 = "shir-subnet"
#  virtual_network_name = azurerm_virtual_network.vnet-shirs.name
#  resource_group_name  = azurerm_resource_group.adf-rg.name
#  depends_on = [
#    azurerm_virtual_network.vnet-shirs
#  ]
#}

#resource "azurerm_virtual_network" "vnet-shirs" {
#  name                = "vnet-${var.web-app-name}-${var.env_name}-01"
#  location            = azurerm_resource_group.resource_group.location
#  resource_group_name = azurerm_resource_group.resource_group.name
#  address_space       = ["10.0.0.0/24"]
#  subnet {
#    name           = "shir-subnet"
#    address_prefix = "10.0.0.0/27"
#  }
#}

# ----------------------- SHIR App Service -----------------------

resource "azurerm_service_plan" "adf-sp" {
  name                = var.app-service-plan-name
  location            = azurerm_resource_group.adf-rg.location
  resource_group_name = azurerm_resource_group.adf-rg.name
  sku_name            = local.appservice-skuname # See https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans for details
  os_type             = "Windows"
} # TODO: Nothing really to see for deployment center, weird compared to Bicep. There I have proper deployment slots. In Bicep on my machine it works!!!

# Create the web app, pass in the App Service Plan ID
resource "azurerm_windows_web_app" "adf-shirs" {
  name                = var.web-app-name
  location            = azurerm_resource_group.adf-rg.location
  resource_group_name = azurerm_resource_group.adf-rg.name
  service_plan_id     = azurerm_service_plan.adf-sp.id
  site_config {
    container_registry_use_managed_identity = true
    #always_on                               = true
    #ftps_state                              = "Disabled"
    application_stack {
      docker_container_name     = local.shir-container-name
      docker_container_tag      = local.shir-container-version
      docker_container_registry = local.acr-url
    }
  }
  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    # The URL for the container registry.
    DOCKER_REGISTRY_SERVER_URL          = local.acr-url
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    CONTAINER_AVAILABILITY_CHECK_MODE : "Off"
    AUTH_KEY  = var.adf-authkey
    NODE_NAME = local.appservice-nodename
    ENABLE_HA = true
    HA_PORT   = local.irNodeRemoteAccessPort
    ENABLE_AE = true
    AE_TIME   = local.irNodeExpirationTime
  }
  logs {
    detailed_error_messages = true
    application_logs {
      file_system_level = "Verbose"
    }
  }
}

resource "azurerm_role_assignment" "acr_role_assignment" {
  role_definition_name = "AcrPull"
  scope                = var.acr-id
  principal_id         = azurerm_windows_web_app.adf-shirs.identity[0].principal_id
}
