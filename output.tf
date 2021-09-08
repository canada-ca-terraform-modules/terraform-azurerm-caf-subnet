output "object" {
  value       = azurerm_subnet.subnet
  description = "Returns the full Azure Subnet Object"
}

output "address_prefix" {
  value       = azurerm_subnet.subnet.address_prefix
  description = "Returns the Azure Subnet address_prefix"
}

output "address_prefixes" {
  value       = azurerm_subnet.subnet.address_prefixes
  description = "Returns the Azure Subnet address_prefixes"
}

output "id" {
  value       = azurerm_subnet.subnet.id
  description = "Returns the Azure Subnet id"
}