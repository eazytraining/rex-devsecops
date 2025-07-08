module "recipe_vpc" {
  source         = "../modules/vpc"
  vpc_name       = "recipe-vpc"
  vpc_cidr_block = "10.1.0.0/16"
}

module "public_subnet" {
  source            = "../modules/subnet"
  vpc_id            = module.recipe_vpc.stack_vpc_id
  subnet_cidr_block = "10.1.1.0/24"
  subnet_name       = "recipe_public_subnet"
  subnet_AZ         = var.recipe_AZ
}

module "recipe_igw" {
  source   = "../modules/igw"
  igw_name = "recipe_igw"
  vpc_id   = module.recipe_vpc.stack_vpc_id
}

module "recipe_igw_route_table" {
  source           = "../modules/route_table"
  vpc_id           = module.recipe_vpc.stack_vpc_id
  route_table_name = "recipe_igw_route_table"
}

resource "aws_route" "internet_access" {
  route_table_id         = module.recipe_igw_route_table.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.recipe_igw.igw_id
}

resource "aws_route_table_association" "public_subnet_to_recipe_igw" {
  subnet_id      = module.public_subnet.subnet_id
  route_table_id = module.recipe_igw_route_table.route_table_id
}

module "sg" {
  source         = "../modules/sg"
  sg_name        = "recipe-sg"
  vpc_id         = module.recipe_vpc.stack_vpc_id
  vpc_cidr_block = ["0.0.0.0/0"]
}

module "keypair" {
  source           = "../modules/keypair"
  key_name         = "recipe-k8s"
  private_key_path = "../.secrets/${module.keypair.key_name}.pem"
}

data "aws_ami" "rex_devsecops_master" {
  most_recent = true
  owners      = ["767397965014"] # ou "self" si tu utilises ton propre compte

  filter {
    name   = "name"
    values = ["rex-devsecops-master-*"]
  }
}

module "recipe_master_ec2" {
  depends_on    = [module.sg, module.keypair]
  source        = "../modules/ec2"
  subnet_id     = module.public_subnet.subnet_id
  aws_ami_id = data.aws_ami.rex_devsecops_master.id
  instance_type = "t3.medium"
  aws_common_tag = {
    Name = "recipe_master_ec2"
  }
  key_name           = module.keypair.key_name
  security_group_ids = [module.sg.aws_sg_id]
  # security_groups = [module.sg.aws_sg_name]
  private_key    = module.keypair.private_key
  user_data_path = "../scripts/userdata_master.sh"
  # user_data_path = templatefile("../scripts/userdata_master.tpl", {
  #   kubernetes_role                    = "control_plane"
  #   kubernetes_apiserver_advertise_address = module.recipe_master_ec2.private_ip
  # })
}

data "aws_ami" "rex_devsecops_worker" {
  most_recent = true
  owners      = ["767397965014"] # ou "self" si tu utilises ton propre compte

  filter {
    name   = "name"
    values = ["rex-devsecops-worker-*"]
  }
}

module "recipe_worker_ec2" {
  count = var.worker_count
  depends_on    = [module.sg, module.keypair, module.recipe_master_ec2]
  source        = "../modules/ec2"
  subnet_id     = module.public_subnet.subnet_id
  aws_ami_id = data.aws_ami.rex_devsecops_worker.id
  instance_type = "t3.medium"
  aws_common_tag = {
    Name = "recipe_worker_ec2_${count.index + 1}"
  }
  key_name           = module.keypair.key_name
  security_group_ids = [module.sg.aws_sg_id]
  # security_groups = [module.sg.aws_sg_name]
  private_key    = module.keypair.private_key
  user_data_path = "../scripts/userdata_worker.sh"
  # user_data_path = templatefile("../scripts/userdata_worker.tpl", {
  #   kubernetes_apiserver_advertise_address = module.recipe_master_ec2.private_ip
  # })
}

module "recipe_master_eip" {
  depends_on = [ module.recipe_master_ec2 ]
  source = "../modules/eip"
  eip_tags = {
    Name = "recipe_master_eip"
  }
}

module "recipe_master_ebs" {
  source = "../modules/ebs"
  AZ     = var.recipe_AZ
  size   = 20
  ebs_tag = {
    Name = "recipe_worker_ebs"
  }
}

resource "aws_eip_association" "recipe_eip_assoc" {
  instance_id   = module.recipe_master_ec2.ec2_instance_id
  allocation_id = module.recipe_master_eip.eip_id
}

resource "aws_volume_attachment" "recipe_ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.recipe_master_ebs.aws_ebs_volume_id
  instance_id = module.recipe_master_ec2.ec2_instance_id
}

resource "null_resource" "output_metadata" {
  depends_on = [module.recipe_master_eip, module.recipe_master_ec2]
  
  provisioner "local-exec" {
    command = "echo recipe_master PUBLIC_IP: ${module.recipe_master_eip.public_ip} - recipe_master PUBLIC_DNS: ${module.recipe_master_eip.public_dns}  >> recipe_ec2.txt"
  }
}
