
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "vault" {
  name     = var.akv_resource_group
  location = var.key_vault_location
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [
    azurerm_key_vault.vault
  ]
}

resource "azurerm_role_assignment" "kv_reader_role" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Reader"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [
    azurerm_key_vault.vault
  ]
}

resource "azurerm_key_vault" "vault" {
  name                          = var.key_vault_name
  location                      = var.key_vault_location
  resource_group_name           = var.akv_resource_group
  enabled_for_disk_encryption   = false
  tenant_id                     = var.key_vault_tenantid
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  sku_name                      = "standard"
  depends_on                    = [azurerm_resource_group.vault]
  enable_rbac_authorization     = true
  public_network_access_enabled = true
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [var.noc_ip]
  }
}