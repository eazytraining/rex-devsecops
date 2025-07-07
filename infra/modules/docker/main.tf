resource "aws_instance" "docker" {
  ami                         = var.ami_id
  key_name                    = var.key_name
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = ["${var.sg_id}"]
  associate_public_ip_address = true
  # availability_zone           = var.az

  connection {
    type        = "ssh"
    host        = self.public_ip
    private_key = file(var.key_path)
    user        = var.username
  }
  provisioner "remote-exec" {
    scripts = ["../scripts/${var.script}.sh"]
  }
  provisioner "local-exec" {
    
    command = "IP=${self.public_ip}; sed -i 's|MY_HOST_ADDRESS|${IP}/g' ../../ansible/playbook.yml"
    interpreter = ["/bin/bash", "-c"]
  }
  tags = {
    Name = var.instance_name
  }
}

# Use null_resource for better control over local-exec
resource "null_resource" "save_docker_ip" {
  depends_on = [aws_instance.docker]
  
  provisioner "local-exec" {
    command = "echo 'Public IP: ${aws_instance.docker.public_ip}' > ../docker_public_ip.txt"
    interpreter = ["/bin/bash", "-c"]
  }
  
  triggers = {
    instance_id = aws_instance.docker.id
  }
}