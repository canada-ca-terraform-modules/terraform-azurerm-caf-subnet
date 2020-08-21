locals {
  name-regex           = "/[^0-9A-Za-z-_.]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  vnet-prefix          = replace(var.virtual_network.name, "-vnet", "")
  vnet-regex_compliant = replace(local.vnet-prefix, local.name-regex, "")
  #subnet-postfix         = "_${var.userDefinedString}-snet"
  #subnet-regex_compliant = replace(local.subnet-postfix, local.name-regex, "")
  #vnet-substr            = substr(local.vnet-regex_compliant, 0, 80 - length(local.subnet-regex_compliant))
  #subnet-fullName        = "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${var.userDefinedString}-snet", local.name-regex, "")))}${replace("_${var.userDefinedString}-snet", local.name-regex, "")}"
}

resource azurerm_subnet subnet {
  for_each = var.subnets

  name                                           = "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${each.key}-snet", local.name-regex, "")))}${replace("_${each.key}-snet", local.name-regex, "")}"
  virtual_network_name                           = var.virtual_network.name
  resource_group_name                            = var.resource_group.name
  address_prefixes                               = lookup(each.value, "address_prefixes", null)
  service_endpoints                              = lookup(each.value, "service_endpoints", null)
  delegation                                     = lookup(each.value, "delegation", null)
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", false)
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", false)
}

resource azurerm_subnet_route_table_association route_table_association {
  for_each = var.route_tables

  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = each.value.route_table.id
}

resource azurerm_subnet_network_security_group_association network_security_group_association {
  for_each = var.network_security_group

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = each.value.network_security_group.id
}
