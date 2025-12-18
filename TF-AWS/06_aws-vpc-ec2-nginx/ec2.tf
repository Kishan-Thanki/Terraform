resource "aws_instance" "sandbox_ec2_nginx" {
  ami                         = "ami-02b8269d5e85954ef"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.sandbox_nginx_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF

  tags = {
    Name = "sandbox-ec2-nginx"
  }
}
