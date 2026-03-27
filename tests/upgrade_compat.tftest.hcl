# upgrade_compat.tftest.hcl
# Verifies that callers using pre-4.x tfvars format still produce a valid plan,
# ensuring no breaking changes were introduced during the azurerm 4.x upgrade.

mock_provider "azurerm" {}

# Simulate a legacy caller that only set address_prefixes and service_endpoints
# (i.e., did not set the new 4.x arguments) — plan must succeed without changes.
run "legacy_caller_no_new_args" {
  command = plan

  variables {
    env = "Prod"
    resource_group = {
      name = "rg-legacy"
    }
    virtual_network = {
      name = "legacy-vnet"
    }
    subnet = {
      userDefinedString = "web"
      address_prefixes  = ["10.1.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
      # private_link_service_network_policies_enabled deliberately omitted
      # private_endpoint_network_policies deliberately omitted
      # No new 4.x args supplied
    }
  }

  assert {
    condition     = azurerm_subnet.subnet.name == "legacy_web-snet"
    error_message = "Legacy caller naming must still resolve correctly"
  }

  assert {
    condition     = azurerm_subnet.subnet.private_link_service_network_policies_enabled == true
    error_message = "private_link_service_network_policies_enabled must default to true when omitted by legacy caller"
  }

  assert {
    condition     = azurerm_subnet.subnet.private_endpoint_network_policies == "Disabled"
    error_message = "private_endpoint_network_policies must default to Disabled when omitted by legacy caller"
  }
}

# Simulate a legacy caller that explicitly set private_link_service_network_policies_enabled = false
# (the old module defaulted to false; callers that relied on that must still work)
run "legacy_private_link_explicitly_false" {
  command = plan

  variables {
    env = "Dev"
    resource_group = {
      name = "rg-legacy"
    }
    virtual_network = {
      name = "legacy-vnet"
    }
    subnet = {
      userDefinedString                             = "svc"
      address_prefixes                              = ["10.1.2.0/24"]
      private_link_service_network_policies_enabled = false
    }
  }

  assert {
    condition     = azurerm_subnet.subnet.private_link_service_network_policies_enabled == false
    error_message = "Explicit false must be honoured for backward compat"
  }
}
