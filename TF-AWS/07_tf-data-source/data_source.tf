data "aws_ami" "name" {
  most_recent = true
  owners = ["amazon"]
}

data "aws_security_group" "name" {
  tags = {
    Name = "sandbox-sg"
  }
}

data "aws_availability_zones" "names" {
  state = "available"
}

data "aws_caller_identity" "name" { 
}

data "aws_region" "name" { 
}