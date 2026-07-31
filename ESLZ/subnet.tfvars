subnets = {
  # --- EXISTING PATTERN (minimally required) ---
  app-subnet = {
    userDefinedString = "app"
    address_prefixes  = ["10.0.1.0/24"]
  }

  # --- EXAMPLE WITH COMMON OPTIONS ---
  # svc-subnet = {
  #   userDefinedString = "svc"
  #   address_prefixes  = ["10.0.2.0/24"]
  #   service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
  #   custom_name       = "override-subnet-name"   # optional: skips naming formula
  #
  #   private_endpoint_network_policies             = "Enabled"   # Disabled | Enabled | NetworkSecurityGroupEnabled | RouteTableEnabled
  #   private_link_service_network_policies_enabled = false        # set false when hosting a Private Link Service
  #
  #   # azurerm >= 4.x: disable default SNAT outbound access (recommended for production)
  #   default_outbound_access_enabled = false
  #
  #   # azurerm >= 4.x: attach service endpoint policies
  #   service_endpoint_policy_ids = [
  #     "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-policies/providers/Microsoft.Network/serviceEndpointPolicies/my-policy"
  #   ]
  # }

  # --- DELEGATION EXAMPLE ---
  # aci-subnet = {
  #   userDefinedString = "aci"
  #   address_prefixes  = ["10.0.3.0/24"]
  #   delegation = {
  #     name = "aci-delegation"
  #     service_delegation = {
  #       name    = "Microsoft.ContainerInstance/containerGroups"
  #       actions = [
  #         "Microsoft.Network/virtualNetworks/subnets/join/action",
  #         "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
  #       ]
  #     }
  #   }
  # }

  # --- IPAM POOL EXAMPLE (azurerm >= 4.x, mutually exclusive with address_prefixes) ---
  # ipam-subnet = {
  #   userDefinedString = "ipam"
  #   # Do NOT set address_prefixes when using ip_address_pool
  #   ip_address_pool = {
  #     id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/networkManagers/nm/ipamPools/pool1"
  #     number_of_ip_addresses = "256"
  #   }
  # }

  # --- SERVICE ENDPOINT EXAMPLE (azurerm >= 5.x) ---
  # azurerm 5.x replaced the `service_endpoints` list(string) argument with one-or-more
  # `service_endpoint` blocks. `service_endpoints` (below) is still accepted for backward
  # compatibility; use `service_endpoint` when you need to pin a `network_identifier`.
  # svc-endpoint-subnet = {
  #   userDefinedString = "svcep"
  #   address_prefixes  = ["10.0.4.0/24"]
  #   service_endpoint = [
  #     { service = "Microsoft.Sql", network_identifier = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/other-subnet" }
  #   ]
  # }

}
