output "sg_id" {
  description = "L'ID du groupe de sécurité K8S"
  value       = aws_security_group.sg.id
}

output "sg_name" {
  description = "Le nom du groupe de sécurité K8S"
  value       = aws_security_group.sg.name
}
