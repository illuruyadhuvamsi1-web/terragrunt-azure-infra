resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = jsondecode(var.address_space)
  tags                = jsondecode(var.tags)
}

resource "azurerm_subnet" "subnets" {
  for_each             = { for i, prefix in jsondecode(var.subnet_prefixes) : i => prefix }
  name                 = "${var.subnet_name}-${each.key}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}
