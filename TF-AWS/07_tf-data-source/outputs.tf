output "aws_ami" {
  value = data.aws_ami.name.id
}

output "aws_security_group" {
  value = data.aws_security_group.name.id
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.names
}

output "caller_info" {
  value = data.aws_caller_identity.name
}

output "aws_region" {
  value = data.aws_region.name
}