# Deploys an Azure Subnet

Creates an Azure Subnet.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| azurerm | >= 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.36.0 |

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

