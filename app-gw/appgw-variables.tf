# App Gateway Variables

variable "appgw_name" {
  type        = string
  description = "App GW Name"
}

variable "appgw_resource_group" {
  description = "App GW Resource Group"
}

variable "appgw_vault_location" {
  description = "App GW Vault Default Region"
}

variable "appgw_frontend_config_name" {
  description = "App GW Frontend Config Name"
}

variable "appgw_frontend_port_name" {
  type        = string
  description = "App GW Frontend Port Config Name"
}

variable "appgw_http_listener_name" {
  type        = string
  description = "App GW HTTP Listener Name"
}

variable "appgw_http_listener_hostname" {
  type        = string
  description = "App GW HTTP Listener Type"
}

variable "appgw_listener_protocol" {
  type        = string
  description = "App GW HTTP Listener Protocol"
}

variable "appgw_ssl_cert_name" {
  type        = string
  description = "App GW Listener SSL Cert Name"
}

variable "appgw_routing_rule_name" {
  type        = string
  description = "App GW Routing Rule Name"
}

variable "appgw_frontend_port" {
  type        = number
  description = "App GW Frontend Port Number"
}

variable "appgw_vnet" {
  type        = string
  description = "App GW VNET Name"
}

variable "appgw_vnet_address" {
  type        = string
  description = "App GW VNET Address Space"
}

variable "appgw_subnet_name" {
  type        = string
  description = "App GW Subnet Name"
}

variable "appgw_subnet_cidr" {
  type        = string
  description = "App GW Subnet CIDR Range"
}

variable "appgw_pubip_name" {
  type        = string
  description = "App GW Public IP Name"
}

variable "appgw_ipconfig_name" {
  type        = string
  description = "App GW IP Config Name"
}

variable "appgw_min_count" {
  type        = number
  description = "App Gateway Autoscaler Min Count"
}

variable "appgw_max_count" {
  type        = number
  description = "App Gateway Autoscaler Max Count"
}

# variable "appgw_enable_http2" {
#   type        = bool
#   description = "Enable HTTP2 Protocol"
# }

# Backend Settings for App Gateway

variable "backend_address_pool1" {
  type        = string
  description = "Backend Address Pool1"
}

variable "backend_address_pool2" {
  type        = string
  description = "Backend Address Pool2"
}

variable "appgw_backend_settings_name1" {
  type        = string
  description = "App Gateway Backend Settings Name for Pool1"
}

variable "appgw_backend_cookies1" {
  type        = string
  description = "App GW Backend Cookie Status for Pool1"
}

# variable "appgw_backend_path1" {
#   type        = string
#   description = "App GW Backend Path for Pool1"
# }

# variable "appgw_backend_hostname1" {
#   type        = string
#   description = "App GW Backend Hostname for Pool1"
# }

variable "appgw_backend_port1" {
  type        = number
  description = "App GW Backend Port for Pool1"
}

variable "appgw_backend_protocol1" {
  type        = string
  description = "App GW Backend Protocol for Pool1"
}

# variable "appgw_backend_timeout1" {
#   type        = number
#   description = "App GW Backend Timeout for Pool1"
# }

variable "appgw_backend_settings_name2" {
  type        = string
  description = "App Gateway Backend Settings Name for Pool2"
}

variable "appgw_backend_cookies2" {
  type        = string
  description = "App GW Backend Cookie Status for Pool2"
}

# variable "appgw_backend_path2" {
#   type        = string
#   description = "App GW Backend Path for Pool2"
# }

# variable "appgw_backend_hostname2" {
#   type        = string
#   description = "App GW Backend Hostname for Pool2"
# }

variable "appgw_backend_port2" {
  type        = number
  description = "App GW Backend Port for Pool2"
}

variable "appgw_backend_protocol2" {
  type        = string
  description = "App GW Backend Protocol for Pool2"
}

# variable "appgw_backend_timeout2" {
#   type        = number
#   description = "App GW Backend Timeout for Pool2"
# }

# Path Routing Rules

variable "appgw_path_rule1_name" {
  type        = string
  description = "nginx path routing rule name"
}

variable "appgw_path_rule2_name" {
  type        = string
  description = "static-ui path routing rule name"
}

variable "appgw_path_rule1_path" {
  type        = string
  description = "nginxplus path match"
}

variable "appgw_path_rule2_path" {
  type        = string
  description = "static-ui path match"
}

variable "appgw_path_rule_name" {
  type        = string
  description = "App GW routing rule name"
}

# WAF Variables

variable "waf_name" {
  type        = string
  description = "WAF Name"
}

variable "waf_mode" {
  type        = string
  description = "WAF Mode (Detection/Prevention)"
}

variable "waf_body_check" {
  type        = bool
  description = "Enable/Disable WAF Request Body Check"
}

variable "waf_file_upload_limit" {
  type        = number
  description = "WAF File Upload Limit in MB"
}

variable "waf_max_request_size" {
  type        = number
  description = "WAF Maximum Request Body Size in KB"
}

variable "waf_owasp_version" {
  type        = string
  description = "WAF OWASP Version"
}

#Azure Key Vault Info
variable "akv_name" {
  type        = string
  description = "Existing Azure Key Vault Name"
}

variable "akv_resource_group" {
  type        = string
  description = "Azure Key Vault resource group"
}

variable "appgw_sku_name" {
  type        = string
  description = "Name/Tier of App GW sku (must Match in most cases)"
}

variable "mi_name" {
  type        = string
  description = "Managed Identity Name"
}

variable "mi_resource_group_name" {
  type        = string
  description = "Resource Group of Managed Identity"
}

variable "appgw_rule_type" {
  type        = string
  description = "APP GW routing rule type"
}

variable "appgw_rewrite_rule_name" {
  type        = string
  description = "APP GW Rewrite Rule Name"
}

variable "appgw_backend2_hostname" {
  type        = string
  description = "Backend Hostname for premium"
}

variable "create_network" {
  type        = bool
  description = "Checks whether network resources (VNET/SUBNET) needs to be created"
}

variable "create_new_resource_group" {
  type = bool
  description = "Checks whether a new resource group needs to be created or use existing"
}

variable "appgw_location" {
  type = string
  description = "Region of the Application Gateway"
}

variable "appgw_frontend_private_config_name" {
  type = string
  description = "Front End Private Config Address Name"
}

variable "appgw_frontend_private_ip" {
  type = string
  description = "Front End Private Config IP Address"
}

variable "appgw_http_private_listener_name" {
  type = string
  description = "HTTP Listener for Private IP Address"
}

variable "appgw_private_routing_rule_name" {
  type = string
  description = "Private Routing Rule Name"
}