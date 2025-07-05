variable "rex_ami" {
  type        = string
  description = "AMI ID for the instances."
  default     = "ami-0c55b159cbfafe1f0" # Example AMI, replace with your own
}
variable "rex_keyname" {
  type        = string
  description = "Name of the key pair to use for the instances."
  default     = "rex-keypair"
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
variable "rex_private_key" {
  type        = string
  description = "Private key for SSH access to the instances."
  default     = ""
}
variable "rex_username" {
  type        = string
  description = "Username for SSH access to the instances."
  default     = "ec2-user"
}
variable "rex_sg_name" {
  type        = string
  description = "Name of the security group to associate with the instances."
  default     = "rex-sg"
}
variable "rex_az" {
  type        = string
  description = "Availability zone for the instances."
  default     = "us-west-2a"
}
variable "rex_script" {
  type        = string
  description = "Script to run on the instances after creation."
  default     = "setup-kubernetes"
}
variable "rex_subnet_id" {
  type        = string
  description = "Subnet ID where the instances will be launched."
  default     = ""
}
variable "rex_sg_id" {
  type        = string
  description = "Security group ID to associate with the instances."
  default     = ""
}