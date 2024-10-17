resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group
}

resource "azurerm_resource_group" "new_vnet_rg" {
  count    = var.create_vnet ? 1 : 0
  location = var.resource_group_location
  name     = var.resource_group
}

# Create virtual network
resource "azurerm_virtual_network" "vm_vnet" {
  count               = var.create_vnet ? 1 : 0
  name                = var.vnet
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.new_vnet_rg[0].name
}

locals {
  vnet_name = var.create_vnet ? azurerm_virtual_network.vm_vnet[0].name : var.vnet_name
  vnet_rg   = var.create_vnet ? var.resource_group : var.existing_vnet_rg
}
# Create subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = var.vm-subnet
  resource_group_name  = local.vnet_rg
  virtual_network_name = local.vnet_name
  address_prefixes     = [var.subnet_cidr]
}

# Create public IPs
resource "azurerm_public_ip" "ubuntu_vm_public_ip" {
  count               = var.install_ubuntu ? 1 : 0
  name                = "${var.ubuntu-vm-name}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "redhat_vm_public_ip" {
  count               = var.install_redhat ? 1 : 0
  name                = "${var.redhat-vm-name}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "windows_vm_public_ip" {
  count               = var.install_windows ? 1 : 0
  name                = "${var.windows-vm-name}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "ubuntu_vm_nsg" {
  count               = var.install_ubuntu ? 1 : 0
  name                = "${var.ubuntu-vm-name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }

  # Allow xRDP (port 3389)
  security_rule {
    name                       = "xRDP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "windows_vm_nsg" {
  count               = var.install_windows ? 1 : 0
  name                = "${var.windows-vm-name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow xRDP (port 3389)
  security_rule {
    name                       = "RDP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "redhat_vm_nsg" {
  count               = var.install_redhat ? 1 : 0
  name                = "${var.redhat-vm-name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }

  # Allow xRDP (port 3389)
  security_rule {
    name                       = "xRDP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "ubuntu_vm_nic" {
  count               = var.install_ubuntu ? 1 : 0
  name                = "${var.ubuntu-vm-name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.ubuntu-vm-name}_nic_config"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ubuntu_vm_public_ip[0].id
  }
}

resource "azurerm_network_interface" "windows_vm_nic" {
  count               = var.install_windows ? 1 : 0
  name                = "${var.windows-vm-name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.windows-vm-name}_nic_config"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_vm_public_ip[0].id
  }
}

resource "azurerm_network_interface" "redhat_vm_nic" {
  count               = var.install_redhat ? 1 : 0
  name                = "${var.redhat-vm-name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.windows-vm-name}_nic_config"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.redhat_vm_public_ip[0].id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.ubuntu_vm_nic[0].id
  network_security_group_id = azurerm_network_security_group.ubuntu_vm_nsg[0].id
}

resource "azurerm_network_interface_security_group_association" "windows_example" {
  count                     = var.install_windows ? 1 : 0
  network_interface_id      = azurerm_network_interface.windows_vm_nic[0].id
  network_security_group_id = azurerm_network_security_group.windows_vm_nsg[0].id
}

resource "azurerm_network_interface_security_group_association" "redhat_example" {
  count                     = var.install_redhat ? 1 : 0
  network_interface_id      = azurerm_network_interface.redhat_vm_nic[0].id
  network_security_group_id = azurerm_network_security_group.redhat_vm_nsg[0].id
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "windows_vm" {
  count                 = var.install_windows ? 1 : 0
  name                  = var.windows-vm-name
  admin_username        = var.login_username
  admin_password        = var.login_password
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.windows_vm_nic[0].id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "WindowsOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "redhat_vm" {
  count                           = var.install_redhat ? 1 : 0
  name                            = var.redhat-vm-name
  admin_username                  = var.login_username
  admin_password                  = var.login_password
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.redhat_vm_nic[0].id]
  size                            = "Standard_DS1_v2"
  disable_password_authentication = false

  os_disk {
    name                 = "RedhatmOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8_4"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "main_ubuntu" {
  count                           = var.install_ubuntu ? 1 : 0
  name                            = var.ubuntu-vm-name
  admin_username                  = var.login_username
  admin_password                  = var.login_password
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.ubuntu_vm_nic[0].id]
  size                            = "Standard_DS1_v2"
  disable_password_authentication = false
  #   custom_data = filebase64("${path.module}/cloudinit/install.sh")

  os_disk {
    name                 = "UbuntuOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Connection block to establish SSH connection
  connection {
    type     = "ssh"
    user     = var.login_username
    password = var.login_password
    host     = azurerm_public_ip.ubuntu_vm_public_ip[0].ip_address
    timeout  = "5m"
  }

  provisioner "file" {
    source      = "${path.module}/packages/openshift-client-linux.tar.gz"
    destination = "/home/installer/openshift-client-linux.tar.gz"
  }

  # Use remote-exec provisioner to run commands on the VM
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y && sudo apt-get install -y xfce4-session xfce4-goodies",
      "curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null",
      "sudo apt-get install apt-transport-https --yes",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main\" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list",
      "sudo apt-get update",
      "sudo apt-get install helm -y",
      "sudo apt-get update && sudo apt install software-properties-common -y",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      "sudo apt install make -y",
      "sudo apt-get install -y python3-venv",
      "sudo tar xvf /home/installer/openshift-client-linux.tar.gz",
      "sudo mv kubectl oc /usr/local/bin/",
      "rm -rf /home/installer/openshift-client-linux.tar.gz",
      "rm -rf /home/installer/README.md",
      "git clone https://github.com/rh-fran6/energy-aro-cluster.git"
    ]
  }

  depends_on = [
    azurerm_network_interface.ubuntu_vm_nic,
    azurerm_public_ip.ubuntu_vm_public_ip
  ]
}

