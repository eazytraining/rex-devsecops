variable "vpc_id" {
  description = "ID du VPC pour le groupe de sécurité K8S"
  type        = string
}

variable "sg_ports" {
  description = "Liste des ports pour le groupe de sécurité K8S"
  type        = list(number)
  default     = [80, 6443, 2379, 22, 10250] // Ports individuels
}

variable "sg_port_range" {
  description = "Plage de ports pour le groupe de sécurité K8S"
  type        = tuple([number, number])
  default     = [30000, 32767] // Plage de ports
}

variable "sg_name" {
  description = "Nom du groupe de sécurité K8S"
  type        = string
}