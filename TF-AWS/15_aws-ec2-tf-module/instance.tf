provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-admin"
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.5"

  name = "sandbox_ec2"

  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name        = "sandbox-ec2"
    Environment = "dev"
  }
}
