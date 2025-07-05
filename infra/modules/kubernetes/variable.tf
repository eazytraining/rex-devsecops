variable "ami_id_master" {
  description = "AMI ID for the EC2 instances"
  type        = string 
}

variable "ami_id_worker" {
  description = "AMI ID for the EC2 instances"
  type        = string 
}


variable "msr_volume_size" {
  description = "Volume size for the master node"
  type        =string
  default     = 16
  
}
variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
  
}
variable "ami_key_pair_name" {
  description = "Key pair name for the EC2 instances"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
variable "number_of_worker" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs for the Kubernetes cluster"
  type        = string
}

variable "security_groups_ids" {
  description = "Security group IDs for the Kubernetes cluster"
  type        = string
}

variable "worker_volume_size" {
  description = "Volume size for the worker nodes"
  type        = string
  default     = 16
  
}

