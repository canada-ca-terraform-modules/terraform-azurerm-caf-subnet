mock_provider "azurerm" {}

variables {
  env = "Dev"
  resource_group = {
    name = "rg-test"
  }
  virtual_network = {
    name = "test-vnet"
  }
  subnet = {
    userDefinedString = "app"
    address_prefixes  = ["10.0.1.0/24"]
  }
}

run "naming_convention" {
  command = plan

  assert {
    condition     = azurerm_subnet.subnet.name == "test_app-snet"
    error_message = "Name must follow {vnet-prefix}_{userDefinedString}-snet convention"
  }
}

run "naming_convention_custom_name" {
  command = plan

  variables {
    subnet = {
      userDefinedString = "app"
      address_prefixes  = ["10.0.1.0/24"]
      custom_name       = "my-custom-subnet"
    }
  }

  assert {
    condition     = azurerm_subnet.subnet.name == "my-custom-subnet"
    error_message = "custom_name must override the generated name"
  }
}

run "default_values" {
  command = plan

  assert {
    condition     = azurerm_subnet.subnet.private_endpoint_network_policies == "Disabled"
    error_message = "private_endpoint_network_policies must default to Disabled"
  }

  assert {
    condition     = azurerm_subnet.subnet.private_link_service_network_policies_enabled == true
    error_message = "private_link_service_network_policies_enabled must default to true (provider default)"
  }

  assert {
    condition     = azurerm_subnet.subnet.default_outbound_access_enabled == true
    error_message = "default_outbound_access_enabled must default to true (provider default)"
  }
}

run "service_endpoints" {
  command = plan

  variables {
    subnet = {
      userDefinedString = "app"
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    }
  }

  # azurerm 5.x: service_endpoints (list(string)) argument was removed in favour of
  # one-or-more service_endpoint blocks; legacy tfvars format must still work.
  assert {
    condition     = length(azurerm_subnet.subnet.service_endpoint) == 2
    error_message = "service_endpoints (legacy list format) must produce a service_endpoint block per entry"
  }

  assert {
    condition     = contains([for se in azurerm_subnet.subnet.service_endpoint : se.service], "Microsoft.KeyVault")
    error_message = "service_endpoint block must carry over the legacy service_endpoints value"
  }
}

run "service_endpoint_new_format" {
  command = plan

  variables {
    subnet = {
      userDefinedString = "app"
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoint = [
        { service = "Microsoft.Sql", network_identifier = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet2" },
      ]
    }
  }

  assert {
    condition     = length(azurerm_subnet.subnet.service_endpoint) == 1
    error_message = "New service_endpoint object format must produce a service_endpoint block"
  }

  assert {
    condition     = azurerm_subnet.subnet.service_endpoint[0].network_identifier != null
    error_message = "network_identifier must be set when provided via the new service_endpoint format"
  }
}

run "service_endpoint_null_values" {
  command = plan

  variables {
    subnet = {
      userDefinedString = "app"
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = null
      service_endpoint  = null
    }
  }

  assert {
    condition     = length(azurerm_subnet.subnet.service_endpoint) == 0
    error_message = "Null service endpoint inputs must be treated the same as unset inputs"
  }
}

run "default_outbound_access_disabled" {
  command = plan

  variables {
    subnet = {
      userDefinedString               = "app"
      address_prefixes                = ["10.0.1.0/24"]
      default_outbound_access_enabled = false
    }
  }

  assert {
    condition     = azurerm_subnet.subnet.default_outbound_access_enabled == false
    error_message = "default_outbound_access_enabled must be configurable"
  }
}

run "service_endpoint_policy_ids" {
  command = plan

  variables {
    subnet = {
      userDefinedString           = "app"
      address_prefixes            = ["10.0.1.0/24"]
      service_endpoint_policy_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/serviceEndpointPolicies/policy1"]
    }
  }

  assert {
    condition     = length(azurerm_subnet.subnet.service_endpoint_policy_ids) == 1
    error_message = "service_endpoint_policy_ids must be set when provided"
  }
}

run "private_link_service_policies_disabled" {
  command = plan

  variables {
    subnet = {
      userDefinedString                             = "app"
      address_prefixes                              = ["10.0.1.0/24"]
      private_link_service_network_policies_enabled = false
    }
  }

  assert {
    condition     = azurerm_subnet.subnet.private_link_service_network_policies_enabled == false
    error_message = "private_link_service_network_policies_enabled must be configurable to false"
  }
}

run "delegation" {
  command = plan

  variables {
    subnet = {
      userDefinedString = "aci"
      address_prefixes  = ["10.0.2.0/24"]
      delegation = {
        name = "aci-delegation"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    }
  }

  assert {
    condition     = length(azurerm_subnet.subnet.delegation) == 1
    error_message = "delegation block must be present when delegation is configured"
  }
}
