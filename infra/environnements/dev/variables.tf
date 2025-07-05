variable "environment" {
  description = "Environment for the infrastructure"
  type        = string
  default     = "dev"

}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = string
  default     = "rex"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.1.0.0/24"
}

variable "sg_ports" {
  description = "Liste des ports pour le groupe de sécurité K8S"
  type        = list(number)
  default     = [80, 6443, 2379, 22, 10250] // Ports individuels
}

variable "sg_port_range" {
  description = "Plage de ports pour le groupe de sécurité K8S"
  type        = tuple([number, number])
  default     = [30000, 30003] // Plage de ports
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"

}

variable "number_of_worker" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}
variable "msr_volume_size" {
  description = "Volume size for the master node"
  type        = number
  default     = 16

}
variable "worker_volume_size" {
  description = "Volume size for the worker nodes"
  type        = number
  default     = 16

}
