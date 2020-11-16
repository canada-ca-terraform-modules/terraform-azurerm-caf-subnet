resource "azurerm_resource_group" "test-RG" {
  name     = "test-${local.template_name}-rg"
  location = var.location
}

module test-vnet {
  source            = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-virtual_network?ref=v1.1.0"
  env               = var.env
  userDefinedString = "test"
  resource_group    = azurerm_resource_group.test-RG
  address_space     = ["10.144.94.0/24"]
  tags              = var.tags
}

locals {
  network = {
    routes = [
      {
        name                   = "toCore"
        address_prefix         = "10.144.0.0/20"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.144.4.10"
      }
    ]
    subnets = {
      PAZ = ["10.144.94.0/27"]
      OZ  = ["10.144.94.32/27"]
      RZ  = ["10.144.94.64/27"]
      MAZ = ["10.144.94.96/27"]
    }
  }
}

resource azurerm_route_table Global-rt {
  name                = "test_Global-rt"
  location            = azurerm_resource_group.test-RG.location
  resource_group_name = azurerm_resource_group.test-RG.name

  dynamic "route" {
    for_each = lookup(local.network, "routes", [])
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = var.tags
}