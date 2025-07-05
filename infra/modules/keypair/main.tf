resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "file" {
  filename        = var.key_path
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0400"
}