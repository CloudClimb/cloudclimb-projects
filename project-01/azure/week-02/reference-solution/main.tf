terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "project" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "project" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = var.app_subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = [var.app_subnet_prefix]
}

resource "azurerm_subnet" "data" {
  name                 = var.data_subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = [var.data_subnet_prefix]
}

resource "azurerm_subnet" "management" {
  name                 = var.management_subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = [var.management_subnet_prefix]
}

resource "azurerm_network_security_group" "app" {
  name                = "cloudclimb-project01-app-nsg"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "data" {
  name                = "cloudclimb-project01-data-nsg"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "management" {
  name                = "cloudclimb-project01-management-nsg"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id

}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id

}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id

}

resource "azurerm_public_ip" "app_vm" {
  name                = "cloudclimb-project01-app-pip"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "app_vm" {
  name                = "cloudclimb-project01-app-nic"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_vm.id
  }

  tags = var.tags
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                       = "Allow-SSH"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "YOUR_PUBLIC_IP/32"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.project.name
  network_security_group_name = azurerm_network_security_group.app.name
}

resource "azurerm_linux_virtual_machine" "app_vm" {
  name                = "cloudclimb-project01-app-vm"
  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location
  size                = "Standard_D2s_v7"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.app_vm.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}
