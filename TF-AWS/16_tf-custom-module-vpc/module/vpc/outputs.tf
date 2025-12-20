# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Public subnets
output "public_subnets" {
  description = "Public subnet details"
  value = {
    for key in keys(local.public_subnets) : key => {
      subnet_id = aws_subnet.main[key].id
      az        = aws_subnet.main[key].availability_zone
      cidr      = aws_subnet.main[key].cidr_block
      name      = aws_subnet.main[key].tags.Name
    }
  }
}

# Private subnets
output "private_subnets" {
  description = "Private subnet details"
  value = {
    for key in keys(local.private_subnets) : key => {
      subnet_id = aws_subnet.main[key].id
      az        = aws_subnet.main[key].availability_zone
      cidr      = aws_subnet.main[key].cidr_block
      name      = aws_subnet.main[key].tags.Name
    }
  }
}
