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
  ami           = data.aws_ami.name.id
  instance_type = "t2.micro"

  tags = {
    Name = "sandbox-ec2"
  }
}
