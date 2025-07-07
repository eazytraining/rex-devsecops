data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

}



# data "aws_ami" "ubuntu_24_04" {
#   most_recent = true
#   owners      = ["self"] # Important: seulement vos AMIs
#   filter {
#     name   = "name" # Adaptez ce filtre
#     values = ["rex-devsecops-docker*"]
#   }
# }

# data "aws_ami" "k8s_master_image" {
#   most_recent = true
#   owners      = ["self"] # Important: seulement vos AMIs
#   filter {
#     name   = "name" # Adaptez ce filtre
#     values = ["rex-devsecops-master*"]
#   }
# }

# data "aws_ami" "k8s_worker_image" {
#   most_recent = true
#   owners      = ["self"] # Important: seulement vos AMIs
#   filter {
#     name   = "name" # Adaptez ce filtre
#     values = ["rex-devsecops-worker*"]
#   }
# }