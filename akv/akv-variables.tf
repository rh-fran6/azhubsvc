
variable "akv_resource_group" {
  description = "Vault Resource Group"
}

variable "key_vault_location" {
  description = "Azure Key Vault Default Region"
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault Name"
}

variable "key_vault_tenantid" {
  type        = string
  description = "Azure Key Vault Tenant ID"
}

variable "noc_ip" {
  type        = string
  description = "NOC Source Subnet"
}

