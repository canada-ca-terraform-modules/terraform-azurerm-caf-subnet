output "object" {
  value       = azurerm_subnet.subnet
  sensitive   = true
  description = "Returns the full Azure Subnet Object"
}

output "address_prefixes" {
  value       = azurerm_subnet.subnet.address_prefixes
  description = "Returns the Azure Subnet address_prefixes"
}

output "id" {
  value       = azurerm_subnet.subnet.id
  description = "Returns the Azure Subnet id"
}

output "network_security_group_id" {
  value       = azurerm_subnet.subnet.network_security_group_id
  description = "Returns the ID of the Network Security Group associated with the Azure Subnet (azurerm >= 5.x)"
}

output "route_table_id" {
  value       = azurerm_subnet.subnet.route_table_id
  description = "Returns the ID of the Route Table associated with the Azure Subnet (azurerm >= 5.x)"
}
