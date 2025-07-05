resource "aws_key_pair" "rex_key" {
  key_name   = var.rex_key
  public_key = tls_private_key.rex_private_key.public_key_openssh
}

resource "tls_private_key" "rex_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "rex_file" {
  filename        = var.rex_key_filename
  content         = tls_private_key.rex_private_key.private_key_pem
  file_permission = "0400"
}