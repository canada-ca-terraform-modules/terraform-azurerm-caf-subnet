# Deploys an Azure Subnet

Creates an Azure Subnet.

## Example

```hcl
module test-snet {
  source          = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-subnet"
  virtual_network = module.test-vnet.virtual_network
  resource_group  = azurerm_resource_group.test-RG
  env             = var.env
  subnets = {
    PAZ = { address_prefixes = local.network.subnets.PAZ }
  }
  route_tables = {
    PAZ = { route_table = azurerm_route_table.Global-rt }
  }
}
```