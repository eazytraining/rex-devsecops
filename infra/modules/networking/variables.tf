variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  
}
variable "vpc_tags" {
  description = "Tags for the VPC"
}
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"  
}
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "public_subnet_tags" {
  description = "Tags for the public subnet"
 
}

variable "internet_gateway_tags" {
  description = "Tags for the Internet Gateway"

}
variable "public_rt_tags" {
  description = "Tags for the public route table"
  
}

