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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.36.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | You can use a prefix to add to the list of resource groups you want to create | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group object of the AKV to be created | `any` | n/a | yes |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Map of subnets | `any` | n/a | yes |
| <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network) | virtual\_network object | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_prefixes"></a> [address\_prefixes](#output\_address\_prefixes) | Returns the Azure Subnet address\_prefixes |
| <a name="output_id"></a> [id](#output\_id) | Returns the Azure Subnet id |
| <a name="output_object"></a> [object](#output\_object) | Returns the full Azure Subnet Object |
