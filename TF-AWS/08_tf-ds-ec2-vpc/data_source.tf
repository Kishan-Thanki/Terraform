data "aws_vpc" "sandbox_vpc" {
  tags = {
    Name = "sandbox_vpc"
  }
}

data "aws_security_group" "sandbox_sg" {
  tags = {
    Name = "sandbox-sg"
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.sandbox_vpc.id]
  }

  tags = {
    Name = "private_subnet"
  }
}
