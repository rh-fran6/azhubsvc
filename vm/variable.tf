variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group."
}

variable "vnet" {
  type        = string
  description = "Name of the VNET."
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR of the VNET."
}

variable "vm-subnet" {
  type        = string
  description = "VM Subnet"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR of the Subnet."
}

variable "ubuntu-vm-name" {
  type        = string
  description = "VM Alias - replaces random"
}

variable "source_address" {
  type        = string
  description = "Source IP Address for inbound connection"
}

variable "create_vnet" {
  type        = bool
  description = "Do you want TF to create VNET or use existing"
  default     = true
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNET (if VNET already exists and var.create_vnet is false)"
}

variable "existing_vnet_rg" {
  type        = string
  description = "Existing VNET Resource Group"
}

variable "install_ubuntu" {
  type        = bool
  description = "Install ubuntu VM?"
}

variable "install_windows" {
  type        = bool
  description = "Install Windows VM?"
}

variable "install_redhat" {
  type        = bool
  description = "Install Red Hat VM?"
}

variable "windows-vm-name" {
  type        = string
  description = "Name of Windows VM"
}

variable "redhat-vm-name" {
  type        = string
  description = "Name of Redhat VM"
}

variable "login_username" {
  type        = string
  description = "Login username of VM"
}

variable "login_password" {
  type        = string
  description = "Login password of VM"
}