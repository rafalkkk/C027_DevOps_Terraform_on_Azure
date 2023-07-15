terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "main_rg" {
  name = var.rg_name
}

data "azurerm_virtual_network" "main_vnet" {
  name                = "App_VNET"
  resource_group_name = data.azurerm_resource_group.main_rg.name
}

resource "azurerm_public_ip" "app01vm_pub_ip" {
  name                = "app01vm_ip"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  allocation_method   = "Dynamic"
}

data "azurerm_subnet" "env_subnet" {
  resource_group_name  = data.azurerm_resource_group.main_rg.name
  virtual_network_name = data.azurerm_virtual_network.main_vnet.name
  name                 = var.subnet_name
}

resource "azurerm_network_interface" "app01vm_nic" {
  name                = "app01vm-nic"
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.env_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app01vm_pub_ip.id
  }
}

resource "azurerm_network_security_group" "nsg_rdp" {
  name                = "app01vm-nsg"
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name

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
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
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


resource "azurerm_managed_disk" "disks" {
  for_each             = var.disks
  name                 = each.key
  location             = data.azurerm_resource_group.main_rg.location
  resource_group_name  = data.azurerm_resource_group.main_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = each.value.size
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_data_attachment" {
  for_each           = var.disks
  managed_disk_id    = azurerm_managed_disk.disks[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.app01vm.id
  lun                = each.value.lun
  caching            = each.value.cache
}

output "public_ip" {
  value = azurerm_public_ip.app01vm_pub_ip.ip_address
}

