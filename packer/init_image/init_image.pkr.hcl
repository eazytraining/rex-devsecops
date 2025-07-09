packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


data "amazon-ami" "ubuntu_focal" {
    filters = {
        virtualization-type = "hvm"
        name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
        root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "rex_devsecops" {
  ami_name      = "init_rex_devsecops_${local.timestamp}"
  instance_type = var.instance_type
  ami_description = "Golden Image REX-DevSecOps avec configurations de base"
  ami_prefix = var.ami_prefix
  region        = var.aws_region
  source_ami    = data.amazon-ami.ubuntu_focal.id
  ssh_username  = var.ssh_username
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = var.root_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    project = "rex_devsecops_project"
  }
}

build {
  name    = "rex_devsecops"
  sources = ["source.amazon-ebs.rex_devsecops"]

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

  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    custom_data = {
      build_time = timestamp()
    }
  }
}