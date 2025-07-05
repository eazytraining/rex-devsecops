locals {
  region        = var.region
  env           = var.environment
  ami_id_master = data.aws_ami.k8s_master_image.id
  ami_id_worker = data.aws_ami.k8s_worker_image.id
  ami_id_docker = data.aws_ami.docker_image.id
  key_path      = "./keypair/${local.env}-key.pem"
  key_name      = "${local.env}-keypair"

}

module "vpc" {
  source                = "../../modules/networking"
  cidr_block            = var.cidr_block
  vpc_tags              = "${local.env}-vpc"
  public_subnet_cidr    = var.public_subnet_cidr
  public_subnet_tags    = "${local.env}-subnet"
  public_rt_tags        = "${local.env}-public-rt"
  internet_gateway_tags = "${local.env}-igw"
  region                = local.region
}

module "security_groups" {
  source        = "../../modules/security_groups"
  vpc_id        = module.vpc.vpc_id
  sg_ports      = var.sg_ports
  sg_port_range = var.sg_port_range
  sg_name       = "${local.env}-sg"

}
module "keypair" {
  source   = "../../modules/keypair"
  key_name = local.key_name
  key_path = local.key_path
}

module "kubernetes" {
  source              = "../../modules/kubernetes"
  ami_id_master       = local.ami_id_master
  ami_id_worker       = local.ami_id_worker
  public_subnet_ids   = module.vpc.subnet_id
  instance_type       = var.instance_type
  ami_key_pair_name   = local.key_name
  security_groups_ids = module.security_groups.sg_id
  number_of_worker    = var.number_of_worker
  worker_volume_size  = var.worker_volume_size
  msr_volume_size     = var.msr_volume_size
  count               = var.environment == "kubernetes" ? 1 : 0
}

module "docker" {
  source        = "../../modules/docker"
  ami_id        = local.ami_id_docker
  key_name      = local.key_name
  instance_type = var.instance_type
  instance_name = "${local.env}-rex"
  key_path      = local.key_path
  username      = "ubuntu"
  sg_name       = module.security_groups.sg_name
  # az            = "${local.region}a"
  script    = local.env
  subnet_id = module.vpc.subnet_id
  sg_id     = module.security_groups.sg_id
  count     = var.environment == "docker" ? 1 : 0

}