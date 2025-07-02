packer {
  required_version = ">= 1.9.2, < 2.0.0"
  required_plugins {
    amazon = {
      version = "1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Data source pour l'AMI Ubuntu 22.04 LTS
data "amazon-ami" "ubuntu_22_04" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    architecture        = "x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = [var.ami_owner]
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
      "OS_Version" = "22.04 LTS"
      "SourceAMI"  = data.amazon-ami.ubuntu_22_04.id
    }
  )
}

# Configuration du builder Amazon EBS
source "amazon-ebs" "golden_image" {
  region          = var.aws_region
  source_ami      = data.amazon-ami.ubuntu_22_04.id
  ami_name        = local.ami_name
  ami_description = var.ami_description
  instance_type   = var.instance_type
  ssh_username    = var.ssh_username
  ssh_timeout     = var.ssh_timeout

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags          = local.merged_tags
  snapshot_tags = local.merged_tags
}

# Définition du build
build {
  name    = "golden_image_build"
  sources = ["source.amazon-ebs.golden_image"]

  # Provisioner: Fichier de configuration cloud-init
  provisioner "file" {
    source      = "./defaults.cfg"
    destination = "/tmp/defaults.cfg"
  }

  # Provisioner: Message du jour
  provisioner "file" {
    source      = "./motd"
    destination = "/tmp/motd"
  }

  # Provisioner: Application des configurations
  provisioner "shell" {
    inline = [
      "sudo mv -f /tmp/defaults.cfg /etc/cloud/cloud.cfg.d/99_defaults.cfg",
      "sudo chmod 644 /etc/cloud/cloud.cfg.d/99_defaults.cfg",
      "sudo chown root:root /etc/cloud/cloud.cfg.d/99_defaults.cfg",
      "sudo mv -f /tmp/motd /etc/motd",
      "sudo chmod 644 /etc/motd",
      "sudo chown root:root /etc/motd"
    ]
  }

  # Provisioner: Script d'initialisation principal
  provisioner "shell" {
    script          = "../scripts/init_image.sh"
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "PACKER_BUILD=1"
    ]
  }

  # Post-processor: Génération du manifeste
  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
    custom_data = {
      build_date     = timestamp()
      packer_version = packer.version
      source_ami     = data.amazon-ami.ubuntu_22_04.id
    }
  }
}