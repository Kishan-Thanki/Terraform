terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "terraform-admin"
}

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "sandbox_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sandbox-vpc"
  }
}

# -----------------------------
# Public Subnet
# -----------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = "10.0.2.0/24"

  tags = {
    Name = "sandbox-public-subnet"
  }
}

# -----------------------------
# Private Subnet
# -----------------------------
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.sandbox_vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "sandbox-private-subnet"
  }
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = {
    Name = "sandbox-igw"
  }
}

# -----------------------------
# Public Route Table
# -----------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.sandbox_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "sandbox-public-rt"
  }
}

# -----------------------------
# Route Table Association
# -----------------------------
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_instance" "sandbox_ec2" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "sandbox-ec2"
  }
}