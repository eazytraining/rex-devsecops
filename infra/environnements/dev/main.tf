locals {
  region        = var.region
  env           = var.environment
  ami_id_master = "ami-020cba7c55df1f615"
  ami_id_worker = "ami-020cba7c55df1f615"
  key_path  = "./keypair/${local.env}-key.pem"
  key_name = "${local.env}-keypair"

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
  source = "../../modules/keypair"
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

}