output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.project.name
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.project.name
}

output "vnet_id" {
  description = "Resource ID of the Virtual Network"
  value       = azurerm_virtual_network.project.id
}

output "app_subnet_id" {
  description = "Resource ID of the application subnet"
  value       = azurerm_subnet.app.id
}

output "data_subnet_id" {
  description = "Resource ID of the data subnet"
  value       = azurerm_subnet.data.id
}

output "management_subnet_id" {
  description = "Resource ID of the management subnet"
  value       = azurerm_subnet.management.id
}