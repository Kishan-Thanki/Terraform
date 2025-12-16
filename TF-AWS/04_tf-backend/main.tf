terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }

  backend "s3" {
    bucket = "your_s3_bucket_id"
    key    = "backend.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region  = var.region
  profile = "terraform-admin"
}

resource "aws_instance" "sandbox_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
