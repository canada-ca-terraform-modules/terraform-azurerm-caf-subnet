variable "resource_group" {
  description = "(Required) Resource group object of the subnet to be created"
}

variable "env" {
  description = "env"
}

variable "virtual_network" {
  description = "(Required) virtual_network object"
}

variable "subnets" {
  description = "(Required) map of subnets"
}

variable "route_tables" {
  description = "(Optional) map of subnet to route table"
  default = {}
}

variable "network_security_group" {
  description = "(Optional) map of subnet to NSG"
  default = {}
}