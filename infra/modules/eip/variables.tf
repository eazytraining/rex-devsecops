variable "eip_name" {
  type        = string
  description = "Name of the Elastic IP."
  default     = "dev-eip"
}

variable "instance_id" {
  type        = string
  description = "The ID of the EC2 instance to associate with the EIP."

}