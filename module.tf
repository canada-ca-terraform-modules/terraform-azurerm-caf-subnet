locals {
  name-regex             = "/[^0-9A-Za-z-_.]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  subnet-postfix         = "_${var.subnetShortName}-snet"
  subnet-regex_compliant = replace(local.subnet-postfix, local.name-regex, "")
  vnet-prefix            = replace(var.virtual_network_name, "-vnet", "")
  vnet-regex_compliant   = replace(local.vnet-prefix, local.name-regex, "")
  vnet-substr            = substr(local.vnet-regex_compliant, 0, 80 - length(local.subnet-regex_compliant))
  subnet-fullName        = "${local.vnet-substr}${local.subnet-regex_compliant}"
}

resource "azurerm_subnet" "subnet" {
  name                 = local.subnet-fullName
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.address_prefixes
}