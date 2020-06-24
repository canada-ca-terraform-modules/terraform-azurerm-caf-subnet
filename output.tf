output "object" {
  value = azurerm_subnet.subnet
  description = "returns the full Azure Subnet Object"
}

output "id" {
  value = azurerm_subnet.subnet.id
  description = "returns the ID of Subnet"
}

output "name" {
  value = azurerm_subnet.subnet.name
  description = "returns the name of Subnet"
}

output "resource_group_name" {
  value = azurerm_subnet.subnet.resource_group_name
  description = "returns the resource_group_name of Subnet"
}

output "virtual_network_name" {
  value = azurerm_subnet.subnet.virtual_network_name
  description = "returns the virtual_network_name of Subnet"
}

output "address_prefixes" {
  value = azurerm_subnet.subnet.address_prefixes
  description = "returns the address_prefixes of Subnet"
}