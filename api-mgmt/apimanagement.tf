resource "azurerm_resource_group" "apimgmt_rg" {
  count = var.create_new_resource_group ? 1 : 0
  name     = var.apimgmt_rg_name
  location = var.apimgmt_region
}

data "azurerm_resource_group" "apimgmt_rg" {
  count = var.create_new_resource_group ? 0 : 1
  name     = var.apimgmt_rg_name
}

resource "azurerm_virtual_network" "apimgmt_vnet" {
  count               = var.create_api_mgmgt_network ? 1 : 0
  name                = var.apimgmt_vnet
  resource_group_name = var.apimgmt_rg_name
  location            = local.rg_location
  address_space       = [var.apimgmt_vnet_cidr]
  depends_on = [azurerm_resource_group.apimgmt_rg]
}

resource "azurerm_subnet" "apimgmt_subnet" {
  count                = var.create_api_mgmgt_network ? 1 : 0
  name                 = var.apimgmt_subnet
  resource_group_name  = var.apimgmt_rg_name
  virtual_network_name = azurerm_virtual_network.apimgmt_vnet[0].name
  address_prefixes     = [var.apimgmt_subnet_cidr]
  delegation {
    name = "apim-delegation"
    service_delegation {
      name = "Microsoft.ApiManagement/service"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
  depends_on = [azurerm_virtual_network.apimgmt_vnet]
}

locals {
  rg_location = var.create_new_resource_group ? var.apimgmt_region : data.azurerm_resource_group.apimgmt_rg[0].location
}

resource "azurerm_api_management" "apimgmt" {
  name                = var.apimgmt_name
  location            = local.rg_location
  resource_group_name = var.apimgmt_rg_name
  publisher_name      = var.apimgmt_publisher_name
  publisher_email     = var.apimgmt_publisher_email
  sku_name            = var.apimgmt_sku

  virtual_network_configuration {
    subnet_id = azurerm_subnet.apimgmt_subnet[0].id
  }

  public_network_access_enabled = true

  depends_on = [azurerm_subnet.apimgmt_subnet]  
}

resource "azurerm_api_management_api" "apimgmt-1" {
  name                = "${var.apimgmt_name}-1"
  resource_group_name = var.apimgmt_rg_name
  api_management_name = var.apimgmt_name
  revision            = "1"
  display_name        = "Signals"
  path                = "signals"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("${path.module}/files/Signals_swagger_v2.5.0_with_fixes.json")
  }
  depends_on = [azurerm_api_management.apimgmt]
}

resource "azurerm_api_management_api" "apimgmt-2" {
  name                = "${var.apimgmt_name}-2"
  resource_group_name = var.apimgmt_rg_name
  api_management_name = var.apimgmt_name
  revision            = "1"
  display_name        = "Cohorts"
  path                = "cohorts"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("${path.module}/files/Hybrid_Cohorts_swagger_3.1.1.json")
  }
  depends_on = [azurerm_api_management.apimgmt]
}

resource "azurerm_api_management_api" "apimgmt-3" {
  name                = "${var.apimgmt_name}-3"
  resource_group_name = var.apimgmt_rg_name
  api_management_name = var.apimgmt_name
  revision            = "1"
  display_name        = "Vormir"
  path                = "vormir"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("${path.module}/files/Vormir_v1.3.0_swagger.json")
  }
  depends_on = [azurerm_api_management.apimgmt]
}
