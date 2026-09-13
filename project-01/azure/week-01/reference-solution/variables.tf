variable "resource_group_name" {
  description = "Name of Azure resource group"
  type        = string
}

variable "location" {
  description = "Region where resources are being deployed"
  type        = string
}

variable "vnet_name" {
  description = "Name of Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for Virtual Network"
  type        = list(string)
}

variable "app_subnet_name" {
  description = "Name of the app subnet"
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR range for the app subnet"
  type        = string
}

variable "data_subnet_name" {
  description = "Name of the data subnet"
  type        = string
}

variable "data_subnet_prefix" {
  description = "CIDR range for the data subnet"
  type        = string
}

variable "management_subnet_name" {
  description = "Name of the management subnet"
  type        = string
}

variable "management_subnet_prefix" {
  description = "CIDR range for the management subnet"
  type        = string
}

variable "tags" {
  description = "Common tags applied to project resources"
  type        = map(string)
}