packer {
  required_version = ">= 1.9.2, < 2.0.0"
  required_plugins {
    amazon = {
      version = "1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Data source pour l'AMI Ubuntu 20.04 LTS officielle
data "amazon-ami" "ubuntu_20_04" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    architecture        = "x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }

  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID
  region      = var.aws_region
}

# Locals pour les valeurs calculées
locals {
  timestamp = formatdate("YYYYMMDD-hhmmss", timestamp())
  ami_name  = "${var.ami_prefix}-${local.timestamp}"
  merged_tags = merge(
    var.common_tags,
    {
      "Name"       = local.ami_name
      "OS"         = "Ubuntu"
      "OS_Version" = "20.04 LTS"
      "SourceAMI"  = data.amazon-ami.ubuntu_20_04.id
    }
  )
}

# Configuration du builder Amazon EBS
source "amazon-ebs" "kube_master_image" {
  region          = var.aws_region
  source_ami      = data.amazon-ami.ubuntu_20_04.id
  ami_name        = local.ami_name
  ami_description = var.ami_description
  instance_type   = var.instance_type
  ssh_username    = "ubuntu" # Utilisateur par défaut pour Ubuntu
  ssh_timeout     = var.ssh_timeout

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = var.root_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  tags          = local.merged_tags
  snapshot_tags = local.merged_tags
}

# Définition du build
build {
  name    = "kube_master_image_build"
  sources = ["source.amazon-ebs.kube_master_image"]
  
  # Provisioner: Script d'initialisation principal
  provisioner "shell" {
    script          = "../scripts/kube_master.sh"
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "PACKER_BUILD=1"
    ]
  }
}