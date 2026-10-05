# Resource group name used for the whole project
variable "resource_group_name" {
  description = "Name of Azure resource group"
  type        = string
}

# Main Azure region for the core project resources
# Most of the environment is deployed here
variable "location" {
  description = "Region where resources are being deployed"
  type        = string
}

# Name of the main VNet
variable "vnet_name" {
  description = "Name of Virtual Network"
  type        = string
}

# Address space for the VNet
# Example: 10.10.0.0/16
variable "vnet_address_space" {
  description = "Address space for Virtual Network"
  type        = list(string)
}

# App subnet is where the Linux VM / Memos workload lives
variable "app_subnet_name" {
  description = "Name of the app subnet"
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR range for the app subnet"
  type        = string
}

# Data subnet was originally meant for the PostgreSQL tier
# I kept it in the design even though PostgreSQL had to move regions for this lab
variable "data_subnet_name" {
  description = "Name of the data subnet"
  type        = string
}

variable "data_subnet_prefix" {
  description = "CIDR range for the data subnet"
  type        = string
}

# Reserved management subnet for future admin / management resources
variable "management_subnet_name" {
  description = "Name of the management subnet"
  type        = string
}

variable "management_subnet_prefix" {
  description = "CIDR range for the management subnet"
  type        = string
}

# Common tags applied across the project
# Keeps naming / ownership / environment info consistent
variable "tags" {
  description = "Common tags applied to project resources"
  type        = map(string)
}

# My current public IPv4 address
# Used to lock down SSH and Memos access instead of opening them to everyone
variable "ssh_source_ip" {
  description = "Public IPv4 address allowed to access SSH and Memos"
  type        = string
}

# SSH public key used to access the Linux VM
# This is passed in as a variable so Terraform can run in GitHub Actions
# without depending on a local ~/.ssh file
variable "ssh_public_key" {
  description = "SSH public key used for the Linux VM"
  type        = string
}

# PostgreSQL administrator username
variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
}

# PostgreSQL administrator password
# Marked sensitive so Terraform does not display it normally in output
# Real value should stay in a local tfvars file and not be committed to GitHub
variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}
