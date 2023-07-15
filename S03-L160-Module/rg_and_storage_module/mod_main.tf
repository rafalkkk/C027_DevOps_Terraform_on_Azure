resource "random_id" "sa_suffix" {
  byte_length = 8
  keepers = {
    "sa" = var.base_name
  }
}

resource "azurerm_resource_group" "my_rg" {
  location = "East US"
  name     = "${var.base_name}${format("%02s", var.resource_number)}"
}

resource "azurerm_storage_account" "my_sa" {
  resource_group_name      = azurerm_resource_group.my_rg.name
  location                 = azurerm_resource_group.my_rg.location
  name                     = "${var.base_name}${lower(random_id.sa_suffix.hex)}${format("%02s", var.resource_number)}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  access_tier              = "Cool"
}
