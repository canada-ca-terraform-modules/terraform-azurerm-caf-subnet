variable "resource_group_name" {
  description = "(Required) Resource group name of the subnet to be created"    
}

variable "tags" {
  description = "(Required) Tags to be applied to the AKV to be created"
}

variable "address_prefixes" {
  description = "(Required) address_prefixes"  
}

variable "virtual_network_name" {
 description = "(Required) virtual_network_name"
}

variable "env" {
  description = "Name of the environment"
  type        = string
  default = ""
}

variable "group" {
  description = "Name of the group"
  type        = string
  default = ""
}

variable "project" {
  description = "Name of the project"
  type        = string
  default = ""
}

variable "postfix" {
  description = "(Optional) You can use a postfix to the name of the resource"
  type        = string
  default = ""
}
