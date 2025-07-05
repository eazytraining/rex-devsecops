resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = var.eip_name
  }
}


resource "aws_eip_association" "eip_association" {
  instance_id   = var.instance_id
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_eip.eip]
}

