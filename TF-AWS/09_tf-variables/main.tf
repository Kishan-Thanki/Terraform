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

locals {
  ENV = "DEV"
  name  = "sandbox-ec2"
}

resource "aws_instance" "sandbox_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = var.aws_instance_type

  root_block_device {
    delete_on_termination = true
    volume_size           = var.root_block_config.size
    volume_type           = var.root_block_config.type
  }

  tags = merge(
    var.ec2_instance_tags,
    {
      Name  = local.name
      ENV = local.ENV
    }
  )
}
