locals {
  subnet-postfix = "_${var.subnetShortName}-snet"
  subnet-regex   = regex("[0-9A-Za-z-_.]+", "${var.env}CNR-${var.group}_${var.project}")
  subnet-substr  = substr(local.subnet-regex, 0, 80 - length(local.subnet-postfix))
  subnet-fullName    = "${local.subnet-substr}${local.subnet-postfix}"
}

resource "azurerm_subnet" "subnet" {
  name                 = local.subnet-fullName
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.address_prefixes
}