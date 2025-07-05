data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  az           = "${var.aws_region}a"
  key_path     = "./keypair/${var.rex_env_type}.pem"
  key_name     = var.rex_env_type
  rex_env_type = var.rex_env_type
  rex_sg_name  = "${var.rex_env_type}-sg"
}

module "rex_networking" {
  source                = "./modules/networking"
  rex_vpc_name          = var.rex_vpc_name
  rex_vpc_cidr_block    = var.rex_vpc_cidr_block
  rex_subnet_cidr_block = var.rex_subnet_cidr_block
  rex_subnet_name       = var.rex_subnet_name
  rex_subnet_AZ         = local.az
  rex_route_table_name  = var.rex_route_table_name
  rex_igw_name          = var.rex_igw_name

}


module "ec2_docker" {
  source            = "./modules/docker"
  rex_ami           = data.aws_ami.ubuntu.id
  rex_keyname       = local.key_name
  rex_instance_type = var.rex_instance_type
  rex_instance_name = var.rex_instance_name
  rex_private_key   = local.key_path
  rex_username      = var.rex_username
  rex_sg_id         = module.security_group.rex_sg_id
  rex_subnet_id     = module.rex_networking.rex_subnet_id
  rex_az            = local.az
  rex_script        = var.rex_script
  depends_on        = [module.security_group, module.keypair]
  count             = var.rex_env_type == "docker" ? 1 : 0
}



module "ebs_docker" {
  source          = "./modules/ebs"
  rex_az          = local.az
  rex_volume_name = var.rex_volume_name
  rex_volume_size = var.rex_volume_size
  count           = var.rex_env_type == "docker" ? 1 : 0
  rex_instance_id = module.ec2_docker[0].rex_instance_id
}

module "security_group" {
  source       = "./modules/security_group"
  rex_sg_name  = local.rex_sg_name
  rex_sg_ports = var.rex_sg_ports
  rex_vpc_id   = module.rex_networking.rex_vpc_id
}

module "keypair" {
  source           = "./modules/keypair"
  rex_key_filename = local.key_path
  rex_key          = local.key_name
}



