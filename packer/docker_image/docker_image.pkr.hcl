packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}
data "amazon-ami" "base_image" {
  filters = {
    name                = "init_ubuntu_*" # Adaptez ce filtre
    architecture        = "x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }

  most_recent = true
  owners      = ["self"] # Important: seulement vos AMIs
  region      = "us-east-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "docker_rex_devsecops" {
  ami_name      = "docker_rex_devsecops_${local.timestamp}"
  instance_type = "t2.medium"
  region        = "us-east-1"
  source_ami    = data.amazon-ami.base_image.id # Here Use the AMI ID provided by init image Build
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
  name    = "docker_rex_devsecops"
  sources = ["source.amazon-ebs.docker_rex_devsecops"]

  provisioner "shell" {
    scripts = ["../scripts/docker.sh"]
  }
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    custom_data = {
      build_time = timestamp()
    }
  }
}
