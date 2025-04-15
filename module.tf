locals {
  name-regex                                     = "/[^0-9A-Za-z-_.]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  vnet-prefix                                    = replace(var.virtual_network.name, "-vnet", "")
  vnet-regex_compliant                           = replace(local.vnet-prefix, local.name-regex, "")
}

resource "azurerm_subnet" "subnet" {
  name                                          = try(var.subnet.custom_name, null) != null ? var.subnet.custom_name : "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${var.subnet.userDefinedString}-snet", local.name-regex, "")))}${replace("_${var.subnet.userDefinedString}-snet", local.name-regex, "")}"
  virtual_network_name                          = var.virtual_network.name
  resource_group_name                           = var.resource_group.name
  address_prefixes                              = try(var.subnet.address_prefixes, null)
  service_endpoints                             = try(var.subnet.service_endpoints, null)
  private_link_service_network_policies_enabled = try(var.subnet.private_link_service_network_policies_enabled, false)
  private_endpoint_network_policies             = try(var.subnet.private_endpoint_network_policies, "Disabled")

  dynamic "delegation" {
    for_each = lookup(var.subnet, "delegation", {}) != {} ? [1] : []

    content {
      name = lookup(var.subnet.delegation, "name", null)

      service_delegation {
        name    = try(var.subnet.delegation.service_delegation.name, null)
        actions = try(var.subnet.delegation.service_delegation.actions, null)
      }
    }
  }
}
