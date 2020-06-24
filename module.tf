locals {
  subnet-postfix = "_${var.subnetShortName}-snet"
  subnet-regex   = regex("[0-9A-Za-z-_.]+", local.subnet-postfix)
  vnet-prefix = replace(var.virtual_network_name, "-vnet", "")
  vnet-regex = regex("[0-9A-Za-z-_.]+", local.vnet-prefix)
  vnet-substr  = substr(local.vnet-regex, 0, 80 - length(local.subnet-regex))
  subnet-fullName    = "${local.vnet-substr}${local.subnet-regex}"
}

resource "azurerm_subnet" "subnet" {
  name                 = local.subnet-fullName
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.address_prefixes
}