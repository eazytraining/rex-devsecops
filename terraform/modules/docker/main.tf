resource "aws_instance" "rex_instance" {
  ami                         = var.rex_ami
  key_name                    = var.rex_keyname
  instance_type               = var.rex_instance_type
  subnet_id                   = var.rex_subnet_id
  vpc_security_group_ids      = ["${var.rex_sg_id}"]
  associate_public_ip_address = true
  availability_zone           = var.rex_az

  connection {
    type        = "ssh"
    host        = self.public_ip
    private_key = file(var.rex_private_key)
    user        = var.rex_username
  }
  provisioner "remote-exec" {
    scripts = ["./scripts/${var.rex_script}.sh"]
  }
  # provisioner "local-exec" {
  #   command = "echo IP: ${self.public_ip} > public_ip.txt"
  # }
  provisioner "local-exec" {
    command = "echo ansible_host: ${self.public_ip} > ../03_ansible/host_vars/dev-1.yaml"
  }
  tags = {
    Name = var.rex_instance_name
  }
}