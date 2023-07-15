# Provider block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

locals {
  std_prefix = lower("${var.prefix}-${var.env}")
}

# Get the resource group
data "azurerm_resource_group" "main_rg" {
  name = var.rg_name
}

data "azurerm_virtual_network" "main_vnet" {
  name                = "Terraform_VNET"
  resource_group_name = data.azurerm_resource_group.main_rg.name
}

data "azurerm_subnet" "env_subnet" {
  resource_group_name  = data.azurerm_resource_group.main_rg.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  name                 = var.subnet_name
}

resource "azurerm_public_ip" "dev01vm_pub_ip" {
  name                = "${local.std_prefix}-${var.vm_name}-ip"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "dev01vm_nic" {
  name                = "${local.std_prefix}-${var.vm_name}-nic"
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.env_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev01vm_pub_ip.id
  }
}

resource "azurerm_network_security_group" "nsg_ssh" {
  name                = "${local.std_prefix}-${var.vm_name}-nsg"
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.dev01vm_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_ssh.id
}

resource "azurerm_linux_virtual_machine" "dev01vm" {
  name                = "${local.std_prefix}-${var.vm_name}-vm"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.dev01vm_nic.id,
  ]

  admin_username = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./.ssh/id_rsa.pub")
  }
  disable_password_authentication = !var.enable_password_authentication

  os_disk {
    name                 = "${local.std_prefix}-${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

output "public_ip" {
  value = azurerm_public_ip.dev01vm_pub_ip.ip_address
}
