locals {
  name-regex           = "/[^0-9A-Za-z-_.]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  vnet-prefix          = replace(var.virtual_network.name, "-vnet", "")
  vnet-regex_compliant = replace(local.vnet-prefix, local.name-regex, "")

  # azurerm 5.x: the `service_endpoints` (list(string)) argument was removed in favour of
  # one-or-more `service_endpoint` blocks. Normalize both the legacy list(string) format
  # (existing tfvars) and the new list(object) format (network_identifier support) into a
  # single list so existing callers produce an identical plan.
  _service_endpoint_legacy_values = try(var.subnet.service_endpoints, null)
  _service_endpoint_legacy = local._service_endpoint_legacy_values != null ? [
    for s in local._service_endpoint_legacy_values : { service = s, network_identifier = null }
  ] : []
  _service_endpoint_new        = try(var.subnet.service_endpoint, null) != null ? var.subnet.service_endpoint : []
  service_endpoints_normalized = concat(local._service_endpoint_legacy, local._service_endpoint_new)
}

resource "azurerm_subnet" "subnet" {
  name                 = try(var.subnet.custom_name, null) != null ? var.subnet.custom_name : "${substr(local.vnet-regex_compliant, 0, 80 - length(replace("_${var.subnet.userDefinedString}-snet", local.name-regex, "")))}${replace("_${var.subnet.userDefinedString}-snet", local.name-regex, "")}"
  virtual_network_name = var.virtual_network.name
  resource_group_name  = var.resource_group.name
  address_prefixes     = try(var.subnet.address_prefixes, null)

  # azurerm 4.x: control whether default (SNAT) outbound access is permitted (provider default = true)
  default_outbound_access_enabled = try(var.subnet.default_outbound_access_enabled, true)

  # azurerm 4.x: service endpoint policy IDs
  service_endpoint_policy_ids = try(var.subnet.service_endpoint_policy_ids, null)

  # azurerm 4.x: subnet sharing scope (Tenant) — only available to registered users
  sharing_scope = try(var.subnet.sharing_scope, null)

  # Bug-fix: provider default is true; previous code defaulted to false
  private_link_service_network_policies_enabled = try(var.subnet.private_link_service_network_policies_enabled, true)
  private_endpoint_network_policies             = try(var.subnet.private_endpoint_network_policies, "Disabled")

  # azurerm 5.x: service_endpoints (list(string)) replaced by one-or-more service_endpoint blocks
  dynamic "service_endpoint" {
    for_each = local.service_endpoints_normalized

    content {
      service            = service_endpoint.value.service
      network_identifier = try(service_endpoint.value.network_identifier, null)
    }
  }

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

  # azurerm 4.x: Network Manager IPAM pool — mutually exclusive with address_prefixes
  dynamic "ip_address_pool" {
    for_each = try(var.subnet.ip_address_pool, null) != null ? [var.subnet.ip_address_pool] : []

    content {
      id                     = ip_address_pool.value["id"]
      number_of_ip_addresses = ip_address_pool.value["number_of_ip_addresses"]
    }
  }
}
