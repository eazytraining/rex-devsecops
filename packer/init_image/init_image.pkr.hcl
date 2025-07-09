packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}
data "aws_ami" "ubuntu_focal" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "owner-id"
    values = ["099720109477"]
  }
}
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "init_ubuntu" {
  ami_name      = "init_ubuntu_${local.timestamp}"
  instance_type = "t2.medium"
  region        = "us-east-1"
  source_ami    = data.aws_ami.ubuntu_focal.id
  ssh_username  = "ubuntu"
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    project = "aws_labs_project"
  }
}

build {
  name    = "init_ubuntu"
  sources = ["source.amazon-ebs.init_ubuntu"]

  provisioner "file" {
    source      = "./defaults.cfg"
    destination = "/tmp/defaults.cfg"
  }
  provisioner "file" {
    source      = "../scripts/motd"
    destination = "/tmp/motd"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/defaults.cfg /etc/cloud/cloud.cfg.d/defaults.cfg",
      "sudo mv /tmp/motd /etc/motd"
    ]
  }

  provisioner "shell" {
    scripts = ["../scripts/init.sh"]
  }
}