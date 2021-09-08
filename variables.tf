variable "resource_group" {
  description = "Resource group object of the AKV to be created"
  type        = any
}

variable "env" {
  description = "You can use a prefix to add to the list of resource groups you want to create"
  type        = string
}

variable "virtual_network" {
  description = "virtual_network object"
  type        = any
}

variable "subnet" {
  description = "Map of subnets"
  type        = any
}
