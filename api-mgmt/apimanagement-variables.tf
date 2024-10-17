variable "create_new_resource_group" {
  type = bool
  description = "Do I create a new resource group?"
}
variable "apimgmt_rg_name" {
  type        = string
  description = "API Management Resource Group"
}
variable "apimgmt_name" {
  type        = string
  description = "API Management Name"
}
variable "apimgmt_region" {
  type        = string
  description = "API Management Region"
}
variable "apimgmt_publisher_name" {
  type        = string
  description = "API Management Publisher Name"
}
variable "apimgmt_publisher_email" {
  type        = string
  description = "API Management Publisher email"
}
variable "apimgmt_sku" {
  type        = string
  description = "API Management SKU"
}
variable "create_api_mgmgt_network" {
  type = bool
  description = "Should I create API Management VNET and Subnets?"
}
variable "apimgmt_vnet" {
  type = string
  description = "API Management VNET Name"
}
variable "apimgmt_vnet_cidr" {
  type = string
  description = "API Management VNET CIDR"
}
variable "apimgmt_subnet" {
  type = string
  description = "API Management Subnet Name"
}
variable "apimgmt_subnet_cidr" {
  type = string
  description = "API Management Subnet CIDR"
}