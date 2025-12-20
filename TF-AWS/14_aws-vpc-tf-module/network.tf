provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-admin"
}

data "aws_availability_zones" "name" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "sandbox_vpc"
  cidr = "10.0.0.0/16"
  azs  = data.aws_availability_zones.name.names

  private_subnets = ["10.0.2.0/24"]
  public_subnets  = ["10.0.1.0/24"]

  tags = {
    Name = "sandbox-vpc"
  }
}
