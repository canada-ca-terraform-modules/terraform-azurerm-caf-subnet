locals {
  name-regex           = "/[^0-9A-Za-z-_.]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  vnet-prefix          = replace(var.virtual_network_name, "-vnet", "")
  vnet-regex_compliant = replace(local.vnet-prefix, local.name-regex, "")
  #subnet-postfix         = "_${var.userDefinedString}-snet"
  #subnet-regex_compliant = replace(local.subnet-postfix, local.name-regex, "")
  #vnet-substr            = substr(local.vnet-regex_compliant, 0, 80 - length(local.subnet-regex_compliant))
  #subnet-fullName        = "${local.vnet-substr}${local.subnet-regex_compliant}"
  #subnet-fullName = "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${var.userDefinedString}-snet", local.name-regex, "")))}${replace("_${var.userDefinedString}-snet", local.name-regex, "")}"
}

resource azurerm_subnet subnet {
  for_each             = var.subnets
  name                 = "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${each.value.userDefinedString}-snet", local.name-regex, "")))}${replace("_${each.value.userDefinedString}-snet", local.name-regex, "")}"
  virtual_network_name = var.virtual_network.name
  resource_group_name  = var.resource_group.name
  address_prefixes     = each.value.address_prefixes
}
