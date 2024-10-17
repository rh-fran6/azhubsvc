resource "azurerm_resource_group" "natgw-rg" {
  name     = var.natgw-rg
  location = var.natgw-region
}

data "azurerm_subnet" "assoc-subnet-1" {
  name                 = var.natgw-priv-subnet1
  virtual_network_name = var.natgw-priv-vnet
  resource_group_name  = var.natgw-vnet-rg
}

data "azurerm_subnet" "assoc-subnet-2" {
  name                 = var.natgw-priv-subnet2
  virtual_network_name = var.natgw-priv-vnet
  resource_group_name  = var.natgw-vnet-rg
}

resource "azurerm_public_ip" "natgw-pub-ip" {
  name                = var.natgw-pub-ip-name
  location            = azurerm_resource_group.natgw-rg.location
  resource_group_name = azurerm_resource_group.natgw-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "natgw" {
  name                = var.natgw-name
  location            = azurerm_resource_group.natgw-rg.location
  resource_group_name = azurerm_resource_group.natgw-rg.name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "natgw-assoc-public" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.natgw-pub-ip.id
}

resource "azurerm_subnet_nat_gateway_association" "natgw-assoc-subnet-1" {
  subnet_id      = data.azurerm_subnet.assoc-subnet-1.id
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

resource "azurerm_subnet_nat_gateway_association" "natgw-assoc-subnet-2" {
  subnet_id      = data.azurerm_subnet.assoc-subnet-2.id
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

resource "azurerm_route_table" "natgw_route_table" {
  name                = var.natgw-route-table
  location            = azurerm_resource_group.natgw-rg.location
  resource_group_name = azurerm_resource_group.natgw-rg.name
}

resource "azurerm_route" "route_to_nat_gateway" {
  name                = var.natgw-route
  resource_group_name = azurerm_resource_group.natgw-rg.name
  route_table_name    = azurerm_route_table.natgw_route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
  #   next_hop_in_ip_address = azurerm_nat_gateway.natgw.id
}

resource "azurerm_subnet_route_table_association" "natgw_subnet_route_table-1" {
  subnet_id      = data.azurerm_subnet.assoc-subnet-1.id
  route_table_id = azurerm_route_table.natgw_route_table.id
}

resource "azurerm_subnet_route_table_association" "natgw_subnet_route_table-2" {
  subnet_id      = data.azurerm_subnet.assoc-subnet-2.id
  route_table_id = azurerm_route_table.natgw_route_table.id
}

output "pub_ip" {
  value = azurerm_public_ip.natgw-pub-ip.ip_address
}