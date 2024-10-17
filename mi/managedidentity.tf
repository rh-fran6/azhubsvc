
data "azurerm_resource_group" "mi_rg" {
  name = var.mi_resource_group_name
}

data "azurerm_key_vault" "akv" {
  name                = var.akv_name
  resource_group_name = var.akv_resource_group
}

resource "azurerm_user_assigned_identity" "mi" {
  name                = var.mi_name
  resource_group_name = data.azurerm_resource_group.mi_rg.name
  location            = data.azurerm_resource_group.mi_rg.location
}

resource "azurerm_role_assignment" "akv_read_role-2" {
  scope                = data.azurerm_key_vault.akv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}

output "managed_identity_id" {
  description = "The ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.mi.id
}

output "managed_identity_principal_id" {
  description = "The Principal ID of the Managed Identity (used for role assignment)"
  value       = azurerm_user_assigned_identity.mi.principal_id
}
