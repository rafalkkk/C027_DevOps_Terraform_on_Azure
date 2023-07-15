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

# Create a resource group
resource "azurerm_resource_group" "main_rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = "App_VNET"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = [var.vnet_addressspace]

  subnet {
    name           = "dev_subnet"
    address_prefix = "10.1.1.0/24"
  }

  subnet {
    name           = "tst_subnet"
    address_prefix = "10.1.2.0/24"
  }
}

resource "azurerm_public_ip" "app01vm_pub_ip" {
  name                = "app01vm_ip"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "app01vm_nic" {
  name                = "app01vm-nic"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.main_vnet.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app01vm_pub_ip.id
  }
}

resource "azurerm_network_security_group" "nsg_rdp" {
  name                = "app01vm-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.app01vm_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_rdp.id
}

resource "azurerm_windows_virtual_machine" "app01vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.app01vm_nic.id,
  ]

  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-ent"
    version   = "latest"
  }

  tags = var.tags
}


resource "azurerm_managed_disk" "disk_data" {
  name                 = var.disk_names[0]
  location             = azurerm_resource_group.main_rg.location
  resource_group_name  = azurerm_resource_group.main_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1
}

resource "azurerm_managed_disk" "disk_log" {
  name                 = var.disk_names[1]
  location             = azurerm_resource_group.main_rg.location
  resource_group_name  = azurerm_resource_group.main_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_data_attachment" {
  managed_disk_id    = azurerm_managed_disk.disk_data.id
  virtual_machine_id = azurerm_windows_virtual_machine.app01vm.id
  lun                = var.disk_lunes[0]
  caching            = var.disk_caches[0]
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_log_attachment" {
  managed_disk_id    = azurerm_managed_disk.disk_log.id
  virtual_machine_id = azurerm_windows_virtual_machine.app01vm.id
  lun                = var.disk_lunes[1]
  caching            = var.disk_caches[1]
}


output "public_ip" {
  value = azurerm_public_ip.app01vm_pub_ip.ip_address
}

