variable "name" {}
variable "vpc_cidr_block" {}
variable "tag_value" {}
variable "subnet_count" {
    description = "Total no of subnets (Private and Public each)"
}
variable "newbits" {
    description = "It is  is the number of additional bits with which to extend the prefix. For example, if given a prefix ending in /16 and a newbits value of 4, the resulting subnet address will have length /20"
}
variable "route_table_association_count" {}
variable "map_public_ip_on_launch" {
    default = true
}
variable "route_table_cidr_block" {
    description = "open cidr for network connection"
}