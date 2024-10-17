resource_group_location = "eastus"
resource_group          = "azure-vm"
vnet                    = "azurevm-vnet"
vnet_cidr               = "10.0.0.0/20"
vm-subnet               = "azurevm-subnet"
subnet_cidr             = "10.0.3.0/24"
ubuntu-vm-name          = "ubuntu-vm"
windows-vm-name         = "windows-vm"
redhat-vm-name          = "redhat-vm"
source_address          = "75.158.42.195"
login_username          = "xxxxxxxx"
login_password          = "xxxxxxxxxxxxxxxx"
install_ubuntu          = true
install_windows         = true
install_redhat          = false

## When deploying into existing Network Infra ##
create_vnet      = false
vnet_name        = "mas-aro-vnet"
existing_vnet_rg = "mas-aro-vnet-rg"

