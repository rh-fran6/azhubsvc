## App GW Network Details
create_network     = true
appgw_vnet         = "appgw_vnet"
appgw_vnet_address = "10.0.0.0/22"
appgw_subnet_cidr  = "10.0.0.0/23"
appgw_subnet_name  = "appgw_subnet"

## Managed Identity for AKV Read
mi_name                = "appgw_to_akv_mi"
mi_resource_group_name = "appgw_akv_rg"

## App GW Public IP
appgw_pubip_name = "appgw_pub_ip"

## App Gateway Details ##
create_new_resource_group = true
appgw_name                 = "app-gateway-name"
appgw_resource_group       = "appgw_akv_rg0"
appgw_location       = "eastus"
appgw_sku_name             = "WAF_v2"
appgw_min_count            = 0
appgw_max_count            = 10
appgw_frontend_port_name   = "frontend-port-443"
appgw_frontend_port        = 443
appgw_frontend_config_name = "app-gateway-frontend-ip"
appgw_frontend_private_config_name = "app-gateway-frontend-private-ip"
appgw_frontend_private_ip = "10.0.0.100"

## SSL Cert Details
akv_name            = "appgw-akv007220"
akv_resource_group  = "appgw_akv_rg"
appgw_ssl_cert_name = "premium-guac-ext-ssl-cert"
appgw_vault_location       = "eastus"


## HTTP Listener
appgw_http_listener_name     = "premium-guac-ext-listener_pub"
appgw_http_private_listener_name     = "premium-guac-ext-listener"
appgw_listener_protocol      = "Https"
appgw_http_listener_hostname = "amc-name-premium.seller-domain.com"

## Backend Address Pools
backend_address_pool1 = "mcp-discover-premium-nginxplus-001"
backend_address_pool2 = "mcp-discover-premium-static-001"

## HTTP Backend Settings
# Backend-1
appgw_backend_settings_name1 = "nginxplus-bs-01"
appgw_backend_cookies1       = "Enabled"
appgw_backend_port1          = 443
appgw_backend_protocol1      = "Https"
# appgw_backend_timeout1       = 20

#Backend-2
appgw_backend_settings_name2 = "premium-static-settings"
appgw_backend_cookies2       = "Disabled"
appgw_backend_port2          = 443
appgw_backend_protocol2      = "Https"
appgw_backend2_hostname      = "backend2.domain.com"

## URL Path Map
appgw_path_rule_name = "path-based-routing"

#Path Rule 1
appgw_path_rule1_name = "nginxplus-path"
appgw_path_rule1_path = "/org/NjlkZTgyOWUtN/nferxVDI/"

#Path Rule 2
appgw_path_rule2_name = "static-ui"
appgw_path_rule2_path = "/static/*"

## Routing Table
appgw_routing_rule_name = "premium-route-guac-rule-pub"
appgw_private_routing_rule_name = "premium-route-guac-rule"
appgw_rule_type         = "PathBasedRouting"
appgw_rewrite_rule_name = "custom-x-nfer-seller-id-rewrite"
appgw_ipconfig_name        = "app-gateway-ip-config"


## WAF Policy Variables ##
waf_name              = "appgw-waf"
waf_mode              = "Detection" # "Prevention"
waf_body_check        = true
waf_file_upload_limit = 100
waf_max_request_size  = 128
waf_owasp_version     = "3.2"










