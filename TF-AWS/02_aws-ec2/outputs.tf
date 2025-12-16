output "aws_instance_public_ip" {
  value = aws_instance.sandbox_ec2.public_ip
}