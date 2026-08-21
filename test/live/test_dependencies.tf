# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# Deliberately NOT reusing any shared/production resource group or vnet:
# writing into a shared RG/vnet usually requires elevated, non-sandbox
# permissions. A dedicated throwaway RG+vnet here needs only Contributor on
# the sandbox subscription and can never collide with or affect any
# production subnet.

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group.
  name     = "${var.env}-caf-subnet-live-test-${var.pr_number}-rg"
  location = var.location

  # pr-number tag (ticket 13): lets the nightly orphan sweeper find this RG
  # by tag and match it back to a PR, independent of naming convention.
  # repository tag: the sandbox subscription is shared across module repos
  # (ticket 03), so the sweeper must scope its `pr-number` matches to only
  # this repo's own PRs - otherwise a PR number collision across repos could
  # misclassify (or destroy) another repo's live resource group.
  tags = {
    "pr-number"  = var.pr_number
    "repository" = var.repository
  }
}

resource "azurerm_virtual_network" "live_test" {
  name                = "${var.env}-caf-subnet-live-test-${var.pr_number}-vnet"
  address_space       = ["10.250.0.0/16"]
  location            = azurerm_resource_group.live_test.location
  resource_group_name = azurerm_resource_group.live_test.name
}

locals {
  # terraform-azurerm-caf-subnet expects resource_group/virtual_network as
  # flat { name = ... } objects.
  resource_group = {
    name = azurerm_resource_group.live_test.name
  }

  virtual_network = {
    name = azurerm_virtual_network.live_test.name
  }
}
