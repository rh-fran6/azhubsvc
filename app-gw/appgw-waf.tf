resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = var.waf_name
  resource_group_name = var.appgw_resource_group
  location            = local.rg_location

  policy_settings {
    enabled                     = true
    mode                        = var.waf_mode
    request_body_check          = var.waf_body_check
    file_upload_limit_in_mb     = var.waf_file_upload_limit
    max_request_body_size_in_kb = var.waf_max_request_size
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = var.waf_owasp_version
    }
  }
  depends_on = [ azurerm_resource_group.appgw_rg ]
}
