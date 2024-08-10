# Create a security group
resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg"
  description = "Security group for K3s cluster"


  # Inbound rules
  ingress {
    description      = "Allow all traffic within the security group"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = []
    self  = true
  }

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow K3s server and agent communication"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Modify this to restrict access to specific IPs
  }

  # Outbound rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s-sg"
  }
}
