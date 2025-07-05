terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }
  # backend "s3" {
  #   bucket = "tests3079801"            # nom de ton bucket S3
  #   key    = "terraform.tfstate" # chemin du state dans le bucket
  #   region = "us-east-1"                        # ta région AWS
  #   encrypt = true
  # }
}

provider "aws" {
  region = var.aws_region

}