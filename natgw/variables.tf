variable "natgw-rg" {
  type        = string
  description = "Nat GW Resource Group"
}

variable "natgw-region" {
  type        = string
  description = "NAT GW Region"
}

variable "natgw-pub-ip-name" {
  type        = string
  description = "Public IP Address of NAT GW"
}

variable "natgw-name" {
  type        = string
  description = "Name of the NAT GW"
}

variable "natgw-priv-subnet1" {
  type        = string
  description = "Private Subnet associated with NAT GW"
}

variable "natgw-priv-subnet2" {
  type        = string
  description = "Private Subnet associated with NAT GW"
}

variable "natgw-priv-vnet" {
  type        = string
  description = "VNET where the associated VNET belongs"
}

variable "natgw-vnet-rg" {
  type        = string
  description = "Resource Group of NAT GW VNET"
}

variable "natgw-route-table" {
  type        = string
  description = "NAT GW Route table name"
}

variable "natgw-route" {
  type        = string
  description = "NAT GW Route Name"
}