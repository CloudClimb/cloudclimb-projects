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

output "app_vm_name" {
  value = azurerm_linux_virtual_machine.app_vm.name
}

output "app_vm_public_ip" {
  value = azurerm_public_ip.app_vm.ip_address
}

output "app_vm_private_ip" {
  value = azurerm_network_interface.app_vm.private_ip_address
}

output "app_vm_nic_id" {
  value = azurerm_network_interface.app_vm.id
}output "app_instance_id" {
  value = aws_instance.app.id
}

output "app_public_ip" {
  value = aws_instance.app.public_ip
}
