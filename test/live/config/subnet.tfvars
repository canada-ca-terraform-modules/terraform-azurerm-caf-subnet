# config/subnet.tfvars
# Tracked, ready-to-run fixture for the test/live harness - one representative
# real-usage instance, not a two-code-path engineered fixture and not a
# dormant "_" template.
#
# This deploys into its own throwaway resource group + vnet
# (10.250.0.0/16, see test_dependencies.tf) - no shared "Network" RG/vnet
# permissions needed, and no risk of colliding with any real subnet.

env = "livetest"

subnet = {
  userDefinedString = "livetest"
  address_prefixes  = ["10.250.1.0/24"]

  # Exercises the azurerm 5.x service_endpoints -> service_endpoint compat
  # shim: deliberately using the legacy list(string) key here, as a real
  # pre-upgrade caller would have, so a live-test PR that touches this shim
  # is caught if it stops producing the same plan.
  service_endpoints = ["Microsoft.Storage"]
}
