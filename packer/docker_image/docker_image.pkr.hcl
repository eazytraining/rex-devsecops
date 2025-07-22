packer {
  required_version = ">= 1.9.2, < 2.0.0"
  required_plugins {
    amazon = {
      version = "1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "base_image" {
  filters = {
    name                = "rex-devsecops-*" # Adaptez ce filtre
    architecture        = "x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }

  most_recent = true
  owners      = ["self"] # Important: seulement vos AMIs
  region      = "us-east-1"
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
      "SourceAMI"  = data.amazon-ami.base_image.id
    }
  )
}

# Configuration du builder Amazon EBS
source "amazon-ebs" "docker_image" {
  region          = var.aws_region
  source_ami      = data.amazon-ami.base_image.id
  ami_name        = local.ami_name
  ami_description = var.ami_description
  instance_type   = var.instance_type
  ssh_username    = var.ssh_username
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

# Défdockerion du build
build {
  name    = "docker_image_build"
  sources = ["source.amazon-ebs.docker_image"]

  provisioner "shell" {
    scripts = ["../scripts/docker.sh"]
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "PACKER_BUILD=1"
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    custom_data = {
      build_time = timestamp()
    }
  }
}