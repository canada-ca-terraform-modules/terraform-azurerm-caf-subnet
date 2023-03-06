locals {
  name-regex           = "/[^0-9A-Za-z-_.]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  vnet-prefix          = replace(var.virtual_network.name, "-vnet", "")
  vnet-regex_compliant = replace(local.vnet-prefix, local.name-regex, "")
}

resource "azurerm_subnet" "subnet" {
  name                                          = "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${var.subnet.userDefinedString}-snet", local.name-regex, "")))}${replace("_${var.subnet.userDefinedString}-snet", local.name-regex, "")}"
  virtual_network_name                          = var.virtual_network.name
  resource_group_name                           = var.resource_group.name
  address_prefixes                              = lookup(var.subnet, "address_prefixes", null)
  service_endpoints                             = lookup(var.subnet, "service_endpoints", null)
  private_link_service_network_policies_enabled = lookup(var.subnet, "private_link_service_network_policies_enabled", false)
  private_endpoint_network_policies_enabled     = lookup(var.subnet, "private_endpoint_network_policies_enabled", false)

  dynamic "delegation" {
    for_each = lookup(var.subnet, "delegation", {}) != {} ? [1] : []

    content {
      name = lookup(var.subnet.delegation, "name", null)

      service_delegation {
        name    = lookup(var.subnet.delegation.service_delegation, "name", null)
        actions = lookup(var.subnet.delegation.service_delegation, "actions", null)
      }
    }
  }
}
