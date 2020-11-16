terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 2.34.0"
  features {}
}

module test-snet {
  source          = "../"
  virtual_network = module.test-vnet.virtual_network
  resource_group  = azurerm_resource_group.test-RG
  env             = var.env
  subnets = {
    PAZ = { address_prefixes = local.network.subnets.PAZ }
  }
  route_tables = {
    PAZ = { route_table = azurerm_route_table.Global-rt }
  }
}