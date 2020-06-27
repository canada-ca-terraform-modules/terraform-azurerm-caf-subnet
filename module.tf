locals {
  name-regex           = "/[^0-9A-Za-z-_.]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  vnet-prefix          = replace(var.virtual_network.name, "-vnet", "")
  vnet-regex_compliant = replace(local.vnet-prefix, local.name-regex, "")
  #subnet-postfix         = "_${var.userDefinedString}-snet"
  #subnet-regex_compliant = replace(local.subnet-postfix, local.name-regex, "")
  #vnet-substr            = substr(local.vnet-regex_compliant, 0, 80 - length(local.subnet-regex_compliant))
  #subnet-fullName        = "${local.vnet-substr}${local.subnet-regex_compliant}"
  # subnet-fullName        = "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${var.userDefinedString}-snet", local.name-regex, "")))}${replace("_${var.userDefinedString}-snet", local.name-regex, "")}"
}

resource azurerm_subnet subnet {
  for_each = var.subnets
  name                 = "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${each.key}-snet", local.name-regex, "")))}${replace("_${each.key}-snet", local.name-regex, "")}"
  virtual_network_name = var.virtual_network.name
  resource_group_name  = var.resource_group.name
  address_prefixes     = each.value.address_prefixes
}
/*
resource azurerm_subnet_route_table_association route_table_association {
  for_each       = var.subnets
  count          = each.value.route_table != null ? 1 : 0
  subnet_id      = azurerm_subnet.subnet.[each.value.userDefinedString].id
  route_table_id = each.value.route_table.id
}

resource azurerm_subnet_network_security_group_association network_security_group_association {
  for_each                  = var.subnets
  count                     = each.value.network_security_group != null ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet.[each.value.userDefinedString].id
  network_security_group_id = each.value.network_security_group.id
}
*/