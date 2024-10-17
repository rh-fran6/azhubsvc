variable "mi_location" {
  default = "eastus"
}

variable "mi_resource_group_name" {
  type        = string
  description = "Managed Identity Resource Group"
}

variable "mi_name" {
  type        = string
  description = "Managed Identity Resource Group"
}

variable "akv_name" {
  type        = string
  description = "Existing Azure Key Vault Name"
}

variable "akv_resource_group" {
  type        = string
  description = "Azure Key Vault resource group"
}