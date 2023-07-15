# azurerm_network_security_group.win-nsg:
resource "azurerm_network_security_group" "win-nsg" {
  location            = data.azurerm_resource_group.main_rg.location
  name                = "windows-nsg"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  security_rule = [
    {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "3389"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "AllowAnyCustom3389Inbound"
      priority                                   = 100
      protocol                                   = "Tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
  ]
  tags = {
    "Project" = "NewDevHome"
  }

  timeouts {}
}
