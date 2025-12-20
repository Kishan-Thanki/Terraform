output "vpc_id" {
  description = "VPC ID from VPC module"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnets from VPC module"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnets from VPC module"
  value       = module.vpc.private_subnets
}
