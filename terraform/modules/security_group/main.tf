resource "aws_security_group" "rex_sg" {
  name        = var.rex_sg_name
  description = "Security group for REX instances"
  vpc_id      = var.rex_vpc_id

  dynamic "ingress" {
    for_each = var.rex_sg_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = var.rex_sg_name
  }
}
