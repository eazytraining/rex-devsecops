resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = "security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.sg_ports)
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # bloc unique pour la plage 30000–32767
  ingress {
    from_port        = var.sg_port_range[0]
    to_port          = var.sg_port_range[1]
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.sg_name
  }
}
