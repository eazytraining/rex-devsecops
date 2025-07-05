resource "aws_eip" "rex_eip" {
  domain = "vpc"
  tags = {
    Name = var.rex_eip_name
  }
}


resource "aws_eip_association" "rex_eip_association" {
  instance_id   = var.rex_instance_id
  allocation_id = aws_eip.rex_eip.id
  depends_on    = [aws_eip.rex_eip]
}

