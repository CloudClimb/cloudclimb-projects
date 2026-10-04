# Resource group name
# Useful when I want to quickly confirm which RG this project is using
output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.project.name
}

# VNet name
output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.project.name
}

# Full Azure resource ID for the VNet
# Useful if another resource or module needs to reference the VNet directly
output "vnet_id" {
  description = "Resource ID of the Virtual Network"
  value       = azurerm_virtual_network.project.id
}

# App subnet ID
# This is the subnet where my Linux VM / Memos workload lives
output "app_subnet_id" {
  description = "Resource ID of the application subnet"
  value       = azurerm_subnet.app.id
}

# Data subnet ID
# This was originally meant for the PostgreSQL tier in the same region
output "data_subnet_id" {
  description = "Resource ID of the data subnet"
  value       = azurerm_subnet.data.id
}

# Management subnet ID
# Reserved for future management / admin resources
output "management_subnet_id" {
  description = "Resource ID of the management subnet"
  value       = azurerm_subnet.management.id
}

# Name of the Linux VM running Docker and Memos
output "app_vm_name" {
  description = "Name of the application VM"
  value       = azurerm_linux_virtual_machine.app_vm.name
}

# Public IP used to SSH into the VM and reach Memos
output "app_vm_public_ip" {
  description = "Public IP address of the application VM"
  value       = azurerm_public_ip.app_vm.ip_address
}

# Private IP assigned to the VM inside the app subnet
output "app_vm_private_ip" {
  description = "Private IP address of the application VM"
  value       = azurerm_network_interface.app_vm.private_ip_address
}

# NIC resource ID for the application VM
output "app_vm_nic_id" {
  description = "Resource ID of the application VM NIC"
  value       = azurerm_network_interface.app_vm.id
}

# PostgreSQL server name
output "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.memos.name
}

# PostgreSQL hostname used by Memos to connect to the database
# This is the FQDN I use in the MEMOS_DSN connection string
output "postgres_fqdn" {
  description = "Fully qualified domain name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.memos.fqdn
}
