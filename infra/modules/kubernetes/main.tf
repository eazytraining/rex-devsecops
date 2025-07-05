resource "aws_instance" "ec2_instance_msr" {
    ami = var.ami_id_master
    subnet_id = var.public_subnet_ids
    instance_type = var.instance_type
    key_name = var.ami_key_pair_name
    associate_public_ip_address = true
    security_groups = [ var.security_groups_ids ]
    root_block_device {
    volume_type = "gp2"
    volume_size = var.msr_volume_size
    delete_on_termination = true
    }
    tags = {
        Name = "k8s_msr_1"
    }
    
} 

resource "aws_instance" "ec2_instance_wrk" {
    ami = var.ami_id_worker
    count = var.number_of_worker
    subnet_id = var.public_subnet_ids
    instance_type = var.instance_type
    key_name = var.ami_key_pair_name
    associate_public_ip_address = true
    security_groups = [ var.security_groups_ids ]
    root_block_device {
    volume_type = "gp2"
    volume_size = var.worker_volume_size
    delete_on_termination = true
    }
    tags = {
        Name = "k8s_wrk_${count.index + 1}"
    }
  
    depends_on = [
      aws_instance.ec2_instance_msr
  ]
} 