resource "azurerm_resource_group" "appgw_rg" {
  count = var.create_new_resource_group ? 1 : 0
  name     = var.appgw_resource_group
  location = var.appgw_location
}

data "azurerm_resource_group" "appgw_rg" {
  count = var.create_new_resource_group ? 0 : 1
  name     = var.appgw_resource_group
}

locals {
  rg_location = var.create_new_resource_group ? var.appgw_location : data.azurerm_resource_group.appgw_rg[0].location
}

resource "azurerm_virtual_network" "appgw_vnet" {
  count               = var.create_network ? 1 : 0
  name                = var.appgw_vnet
  resource_group_name = var.appgw_resource_group
  location            = local.rg_location
  address_space       = [var.appgw_vnet_address]
  depends_on = [ azurerm_resource_group.appgw_rg ]
}

resource "azurerm_subnet" "appgw_subnet" {
  count                = var.create_network ? 1 : 0
  name                 = var.appgw_subnet_name
  resource_group_name  = var.appgw_resource_group
  virtual_network_name = azurerm_virtual_network.appgw_vnet[0].name
  address_prefixes     = [var.appgw_subnet_cidr]
}

resource "azurerm_public_ip" "appgw_pubip" {
  name                = var.appgw_pubip_name
  resource_group_name = var.mi_resource_group_name
  location            = local.rg_location
  allocation_method   = "Static"
}

data "azurerm_key_vault" "akv" {
  name                = var.akv_name
  resource_group_name = var.akv_resource_group
}

data "azurerm_key_vault_certificate" "appgw_ssl_cert" {
  name         = var.appgw_ssl_cert_name
  key_vault_id = data.azurerm_key_vault.akv.id
}

data "azurerm_user_assigned_identity" "mi" {
  name                = var.mi_name
  resource_group_name = var.mi_resource_group_name
}

resource "azurerm_application_gateway" "app_gw" {
  name                = var.appgw_name
  resource_group_name = var.appgw_resource_group
  location            = local.rg_location
  firewall_policy_id  = azurerm_web_application_firewall_policy.waf_policy.id

  identity {
    type         = "UserAssigned"
    identity_ids = [ data.azurerm_user_assigned_identity.mi.id ]
  }

  sku {
    name = var.appgw_sku_name
    tier = var.appgw_sku_name
  }

  autoscale_configuration {
    min_capacity = var.appgw_min_count
    max_capacity = var.appgw_max_count
  }

  frontend_port {
    name = var.appgw_frontend_port_name
    port = var.appgw_frontend_port
  }
  ## Public Frontent
  frontend_ip_configuration {
    name                 = var.appgw_frontend_config_name
    public_ip_address_id = azurerm_public_ip.appgw_pubip.id
  }

  ## Private Frontend
  frontend_ip_configuration {
    name                 = var.appgw_frontend_private_config_name
    subnet_id            = azurerm_subnet.appgw_subnet[0].id
    private_ip_address   = var.appgw_frontend_private_ip
    private_ip_address_allocation = "Static"    
  }

  ssl_certificate {
    name                = var.appgw_ssl_cert_name
    key_vault_secret_id = data.azurerm_key_vault_certificate.appgw_ssl_cert.secret_id
  }

  ## Public Listener
  http_listener {
    name                           = var.appgw_http_listener_name
    frontend_ip_configuration_name = var.appgw_frontend_config_name
    frontend_port_name             = var.appgw_frontend_port_name
    protocol                       = var.appgw_listener_protocol
    ssl_certificate_name           = var.appgw_ssl_cert_name
    host_name                      = var.appgw_http_listener_hostname
  }

  ## Private Listener
  http_listener {
    name                           = var.appgw_http_private_listener_name
    frontend_ip_configuration_name = var.appgw_frontend_private_config_name
    frontend_port_name             = var.appgw_frontend_port_name
    protocol                       = var.appgw_listener_protocol
    ssl_certificate_name           = var.appgw_ssl_cert_name
    host_name                      = var.appgw_http_listener_hostname
  }

  backend_address_pool {
    name = var.backend_address_pool1
  }

  backend_address_pool {
    name = var.backend_address_pool2
  }

  ## nginx
  backend_http_settings {
    name                  = var.appgw_backend_settings_name1
    cookie_based_affinity = var.appgw_backend_cookies1
    port     = var.appgw_backend_port1
    protocol = var.appgw_backend_protocol1
    pick_host_name_from_backend_address = true
  }

  ## Premium
  backend_http_settings {
    name                  = var.appgw_backend_settings_name2
    cookie_based_affinity = var.appgw_backend_cookies2
    port     = var.appgw_backend_port2
    protocol = var.appgw_backend_protocol2
    pick_host_name_from_backend_address = false
    host_name                           = var.appgw_backend2_hostname
    # connection_draining {
    #   enabled           = true
    #   drain_timeout_sec = 3600
    # }
  }

  url_path_map {
    name = var.appgw_path_rule_name
    default_backend_address_pool_name  = var.backend_address_pool1
    default_backend_http_settings_name = var.appgw_backend_settings_name1

    # nginx-plus
    path_rule {
      name                       = var.appgw_path_rule1_name
      paths                      = [var.appgw_path_rule1_path]
      backend_address_pool_name  = var.backend_address_pool2
      backend_http_settings_name = var.appgw_backend_settings_name1
    }

    # premium-static
    path_rule {
      name                       = var.appgw_path_rule2_name
      paths                      = [var.appgw_path_rule2_path]
      backend_address_pool_name  = var.backend_address_pool1
      backend_http_settings_name = var.appgw_backend_settings_name2
    }
  }

  rewrite_rule_set {
    name = var.appgw_rewrite_rule_name
    rewrite_rule {
      name          = "custom-x-nfer-seller-id"
      rule_sequence = 100
      request_header_configuration {
        header_name  = "x-nfer-seller-id"
        header_value = "nsights"
      }
    }
  }

  ## Public Routing Table
  request_routing_rule {
    name                  = var.appgw_path_rule_name
    rule_type             = var.appgw_rule_type
    http_listener_name    = var.appgw_http_listener_name
    url_path_map_name     = var.appgw_path_rule_name
    rewrite_rule_set_name = var.appgw_rewrite_rule_name
    priority = 2000
  }

  ## Private Routing Table
  request_routing_rule {
    name                  = var.appgw_private_routing_rule_name
    rule_type             = var.appgw_rule_type
    http_listener_name    = var.appgw_http_private_listener_name
    url_path_map_name     = var.appgw_path_rule_name
    rewrite_rule_set_name = var.appgw_rewrite_rule_name
    priority = 1000
  }

  gateway_ip_configuration {
    name      = var.appgw_ipconfig_name
    subnet_id = azurerm_subnet.appgw_subnet[0].id
  }

  depends_on = [ azurerm_resource_group.appgw_rg ]

}