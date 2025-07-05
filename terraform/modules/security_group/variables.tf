variable "rex_sg_name" {
  type        = string
  description = "Name of the security group to associate with the instances."
  default     = "rex-sg"
}
variable "rex_sg_ports" {
  default = ["22", "80", "443"]
}

variable "rex_vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created."

}