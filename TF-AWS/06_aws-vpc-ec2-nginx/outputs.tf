output "instance_public_ip" {
  description = "The public IP address of the EC2 Instance."
  value = aws_instance.sandbox_ec2_nginx.public_ip
}

output "instance_url" {
  description = "The URL to access the Nginx server."
  value = "http://${aws_instance.sandbox_ec2_nginx.public_ip}"
}