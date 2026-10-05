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

# Main resource group for the whole CloudClimb Project 01 environment
resource "azurerm_resource_group" "project" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Main VNet for the project
# I split this up into app, data, and management subnets so each tier has its own space
resource "azurerm_virtual_network" "project" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

# App subnet - this is where my Linux VM / Memos workload lives
resource "azurerm_subnet" "app" {
  name                 = var.app_subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = [var.app_subnet_prefix]
}

# Data subnet
# I originally planned to put PostgreSQL here with private networking
# but my subscription would not let me provision PostgreSQL Flexible Server in East US
# so this subnet stays here as part of the original architecture
resource "azurerm_subnet" "data" {
  name                 = var.data_subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = [var.data_subnet_prefix]
}

# Management subnet reserved for future admin / management resources
resource "azurerm_subnet" "management" {
  name                 = var.management_subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = [var.management_subnet_prefix]
}

# NSG for the app subnet
resource "azurerm_network_security_group" "app" {
  name                = "cloudclimb-project01-app-nsg"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

# NSG for the data subnet
resource "azurerm_network_security_group" "data" {
  name                = "cloudclimb-project01-data-nsg"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

# NSG for the management subnet
resource "azurerm_network_security_group" "management" {
  name                = "cloudclimb-project01-management-nsg"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  tags                = var.tags
}

# Attach the app NSG to the app subnet
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

# Attach the data NSG to the data subnet
resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}

# Attach the management NSG to the management subnet
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

# Static public IP for the Linux VM
# I use this IP to SSH into the VM and access Memos from my browser
resource "azurerm_public_ip" "app_vm" {
  name                = "cloudclimb-project01-app-pip"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# NIC that connects the VM to the app subnet
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

# SSH rule
# I restrict SSH to my current public IP instead of opening port 22 to everyone
# If I change networks, I have to update ssh_source_ip in terraform.tfvars
resource "azurerm_network_security_rule" "allow_ssh" {
  name                       = "Allow-SSH"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = var.ssh_source_ip
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.project.name
  network_security_group_name = azurerm_network_security_group.app.name
}

# Memos runs on port 5230
# I restricted this to my current public IP too since this is just a lab
resource "azurerm_network_security_rule" "allow_memos" {
  name                        = "Allow-Memos"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5230"
  source_address_prefix       = var.ssh_source_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.project.name
  network_security_group_name = azurerm_network_security_group.app.name
}

# Linux VM that hosts Docker and the Memos container
resource "azurerm_linux_virtual_machine" "app_vm" {
  name                = "cloudclimb-project01-app-vm"
  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location
  size                = "Standard_D2s_v7"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.app_vm.id
  ]

  # Using SSH keys instead of a password
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Ubuntu 22.04 LTS image
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

# PostgreSQL Flexible Server
# My original plan was to keep PostgreSQL private in East US with the app
# but Azure blocked PostgreSQL Flexible Server provisioning in East US for my subscription
# I used Central US as a lab workaround instead of moving the entire environment
resource "azurerm_postgresql_flexible_server" "memos" {
  name                = "cloudclimb-project01-postgres-dev01"
  resource_group_name = azurerm_resource_group.project.name
  location            = "centralus"
  version             = "16"

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  # Small burstable SKU because this is just a development lab
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  # Public access is only being used because the database is in another region
  # I lock it down with a firewall rule below so only the app VM can connect
  public_network_access_enabled = true

  tags = var.tags

  # Azure selected the zone automatically and Terraform kept trying to reconcile it
  # so I ignore zone changes since I'm not using HA for this lab
  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}

# PostgreSQL firewall rule
# This only allows the app VM's public IP to connect to PostgreSQL
# Port 5432 traffic from random internet hosts is still blocked
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_app_vm" {
  name             = "Allow-Memos-VM"
  server_id        = azurerm_postgresql_flexible_server.memos.id
  start_ip_address = azurerm_public_ip.app_vm.ip_address
  end_ip_address   = azurerm_public_ip.app_vm.ip_address
}
