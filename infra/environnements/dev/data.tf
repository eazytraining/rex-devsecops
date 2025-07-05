data "aws_ami" "docker_image" {
  most_recent = true
  owners      = ["self"] # Important: seulement vos AMIs
  filter {
    name   = "name" # Adaptez ce filtre
    values = ["rex-devsecops-docker*"]
  }
}

data "aws_ami" "k8s_master_image" {
  most_recent = true
  owners      = ["self"] # Important: seulement vos AMIs
  filter {
    name   = "name" # Adaptez ce filtre
    values = ["rex-devsecops-master*"]
  }
}

data "aws_ami" "k8s_worker_image" {
  most_recent = true
  owners      = ["self"] # Important: seulement vos AMIs
  filter {
    name   = "name" # Adaptez ce filtre
    values = ["rex-devsecops-worker*"]
  }
}