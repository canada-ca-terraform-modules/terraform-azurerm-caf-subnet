output "object" {
  value       = azurerm_subnet.subnet
  description = "returns the full Azure Subnet Object"
}

output "resource_group_name" {
  value       = azurerm_subnet.subnet.resource_group_name
  description = "returns the resource_group_name of Subnet"
}

output "virtual_network_name" {
  value       = azurerm_subnet.subnet.virtual_network_name
  description = "returns the virtual_network_name of Subnet"
}
