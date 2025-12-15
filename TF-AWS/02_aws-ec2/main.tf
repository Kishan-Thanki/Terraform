terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "sandbox_ec2" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}