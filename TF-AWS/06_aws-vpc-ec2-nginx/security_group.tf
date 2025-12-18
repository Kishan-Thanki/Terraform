resource "aws_security_group" "sandbox_nginx_sg" {
  vpc_id = aws_vpc.sandbox_vpc.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Applicable for all protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sandbox-nginx-sg"
  }
}
