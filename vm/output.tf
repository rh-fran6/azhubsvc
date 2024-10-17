
locals {
  is_windows = var.install_windows
  is_redhat  = var.install_redhat
  is_ubuntu  = var.install_ubuntu

  windows_public_ip = local.is_windows ? azurerm_public_ip.windows_vm_public_ip[0].ip_address : "Windows VM not created"

  redhat_public_ip = local.is_redhat ? azurerm_public_ip.redhat_vm_public_ip[0].ip_address : "Redhat VM not created"

  ubuntu_public_ip = local.is_ubuntu ? azurerm_public_ip.ubuntu_vm_public_ip[0].ip_address : "Ubuntu VM not created"
}

output "windows_ip_address" {
  value = local.windows_public_ip
}

output "redhat_ip_address" {
  value = local.redhat_public_ip
}

output "ubuntu_ip_address" {
  value = local.ubuntu_public_ip
}


