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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| azurerm | >= 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.36.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) |
| [azurerm_subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | You can use a prefix to add to the list of resource groups you want to create | `string` | n/a | yes |
| resource\_group | Resource group object of the AKV to be created | `any` | n/a | yes |
| subnets | Map of subnets | `any` | n/a | yes |
| virtual\_network | virtual\_network object | `any` | n/a | yes |
| network\_security\_group | Map of subnet to NSG | `any` | `{}` | no |
| route\_tables | Map of subnet to route table | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| object | Returns the full Azure Subnet Object |
