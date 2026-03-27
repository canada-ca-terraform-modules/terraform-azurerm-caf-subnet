<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-caf-subnet

Deploys an Azure Subnet following the SSC/CAF naming and tagging standard.

## Usage

### ESLZ module block (`ESLZ/subnet.tf`)

```hcl
module "subnets" {
  source          = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-subnet"
  for_each        = var.subnets
  env             = var.env
  resource_group  = local.resource_groups[each.value.resource_group]
  virtual_network = local.virtual_networks[each.value.virtual_network]
  subnet          = each.value
}
```

### ESLZ tfvars pattern (`ESLZ/subnet.tfvars`)

```hcl
subnets = {
  app-subnet = {
    userDefinedString = "app"
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]

    # azurerm >= 4.x: disable default SNAT outbound (recommended for production)
    default_outbound_access_enabled = false

    # azurerm >= 4.x: attach service endpoint policies
    # service_endpoint_policy_ids = ["/subscriptions/.../serviceEndpointPolicies/policy"]

    # azurerm >= 4.x: IPAM pool (mutually exclusive with address_prefixes)
    # ip_address_pool = { id = "/subscriptions/.../ipamPools/pool1", number_of_ip_addresses = "256" }
  }
}
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `env` | `string` | required | Environment prefix (e.g. Dev, Prod) |
| `resource_group` | `any` | required | Resource group object containing `.name` |
| `virtual_network` | `any` | required | Virtual network object containing `.name` |
| `subnet` | `any` | required | Subnet configuration object (see below) |

### `subnet` object keys

| Key | Type | Default | Description |
|---|---|---|---|
| `userDefinedString` | string | required | Suffix used in naming formula |
| `address_prefixes` | list(string) | `null` | CIDR address prefixes — mutually exclusive with `ip_address_pool` |
| `custom_name` | string | `null` | Override the generated name |
| `service_endpoints` | list(string) | `null` | Service endpoints to associate |
| `service_endpoint_policy_ids` | list(string) | `null` | **New in azurerm 4.x** — service endpoint policy IDs |
| `default_outbound_access_enabled` | bool | `true` | **New in azurerm 4.x** — enable default SNAT outbound access |
| `sharing_scope` | string | `null` | **New in azurerm 4.x** — `Tenant` (registered users only) |
| `private_endpoint_network_policies` | string | `"Disabled"` | `Disabled` \| `Enabled` \| `NetworkSecurityGroupEnabled` \| `RouteTableEnabled` |
| `private_link_service_network_policies_enabled` | bool | `true` | Set `false` when hosting a Private Link Service |
| `delegation` | object | `{}` | Service delegation block — see tfvars example |
| `ip_address_pool` | object | `null` | **New in azurerm 4.x** — Network Manager IPAM pool |

## Outputs

| Name | Description |
|---|---|
| `object` | Full subnet resource object (`sensitive = true`) |
| `address_prefixes` | Subnet address prefixes |
| `id` | Subnet resource ID |

## Requirements

| Name | Version |
|---|---|
| terraform | `>= 1.9` |
| azurerm | `~> 4.0` |

<!-- END_TF_DOCS -->