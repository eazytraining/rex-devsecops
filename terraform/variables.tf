variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created."
  default     = "us-west-2"
}
variable "rex_keyname" {
  type        = string
  description = "Name of the key pair to use for SSH access."
  default     = "rex-key"
}
variable "rex_instance_type" {
  type        = string
  description = "Instance type for the instances."
  default     = "t3.medium"
}
variable "rex_instance_name" {
  type        = string
  description = "Name of the instance."
  default     = "rex-instance"
}
variable "rex_username" {
  type        = string
  description = "Username for SSH access to the instances."
  default     = "ubuntu"
}
variable "rex_sg_name" {
  type        = string
  description = "Name of the security group to associate with the instances."
  default     = "rex-sg"
}

variable "rex_env_type" {
  type        = string
  description = "Environment type (e.g., dev, prod)."
  default     = "dev"

}


variable "rex_volume_name" {
}
variable "rex_volume_size" {
}

variable "rex_sg_ports" {
}
variable "rex_script" {

}

variable "rex_instance_count_master" {
  default = 1
}
variable "rex_instance_count_worker" {
  default = 1
}
variable "rex_ami" {
  type        = string
  description = "AMI ID for the instances."
}          

variable "rex_subnet_name" {
  type        = string
  description = "Name of the subnet to associate with the instances."
  default     = "rex-subnet"
}

variable "rex_vpc_name" {
  default = "rex-vpc"
  type    = string
  description = "Name of the VPC to create."
}
variable "rex_vpc_cidr_block" {
  default = "10.0.0.0/16"
  type    = string
  description = "CIDR block for the VPC."
}
variable "rex_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the subnet."
  default     = "10.0.0/24"
}

variable "rex_igw_name" {
  type        = string
  description = "Name of the Internet Gateway."
  default     = "rex-igw"
  
}

variable "rex_route_table_name" {
  type        = string
  description = "Name of the route table."
  default     = "rex-route-table"
  
}