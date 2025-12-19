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
  project = "sandbox"
}

resource "aws_vpc" "sandbox_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.project}-vpc"
  }
}

resource "aws_subnet" "sandbox_subnet" {
  vpc_id     = aws_vpc.sandbox_vpc.id
  count      = 2
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Name = "${local.project}-subnet-${count.index}"
  }
}

resource "aws_instance" "sandbox_ec2" {
  # Example 1 (Count)
  #   count         = length(var.ec2_config_list)
  #   ami           = var.ec2_config_list[count.index].ami
  #   instance_type = var.ec2_config_list[count.index].instance_type
  #   subnet_id     = element(aws_subnet.sandbox_subnet[*].id, count.index % length(aws_subnet.sandbox_subnet))
  #   tags = {
  #     Name = "${local.project}-ec2-${count.index}"
  #   }

  # Example 2 (For_Each)
  for_each      = var.ec2_config_map
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = element(aws_subnet.sandbox_subnet[*].id, index(keys(var.ec2_config_map), each.key) % length(aws_subnet.sandbox_subnet))
  tags = {
    Name = "${local.project}-ec2-${each.key}"
  }
}

output "aws_subnet_id" {
  value = aws_subnet.sandbox_subnet[0].id
}
