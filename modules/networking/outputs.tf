output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  value = [for s in azurerm_subnet.subnets : s.id]
}