terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }
  required_version = ">= 0.14.1"
}

provider "azurerm" {
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