terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-admin"
}

resource "aws_instance" "sandbox_ec2" {
  ami             = "ami-02b8269d5e85954ef"
  instance_type   = "t2.micro"
  subnet_id       = data.aws_subnet.private_subnet.id
  security_groups = [data.aws_security_group.sandbox_sg.id]

  tags = {
    Name = "sandbox-ec2"
  }
}
