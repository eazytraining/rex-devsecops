variable "rex_route_table_name" {
  type        = string
  description = "Name of the route table."
  default     = "dev-route-table"
}

variable "rex_igw_name" {
  type        = string
  description = "Name of the Internet Gateway."
  default     = "dev-igw"
}

variable "rex_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the subnet."
}

variable "rex_subnet_name" {
  type        = string
  description = "Name of the subnet."
}

variable "rex_subnet_AZ" {
  type        = string
  description = "Availability Zone for the subnet."
}

variable "rex_vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "rex_vpc_cidr_block" {
  type        = string
  description = "set the vpc cidr block"
}