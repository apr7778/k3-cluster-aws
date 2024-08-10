terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "master" {
  ami                    = local.ami
  instance_type          = local.instancetype
  user_data              = file("master.sh")
  key_name               = local.keyname
  vpc_security_group_ids = [aws_security_group.k3s-master-sec-group.id]
  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker" {
  ami                    = local.ami
  instance_type          = local.instancetype
  user_data              = templatefile("worker.sh", {master_node_private_ip = aws_instance.master.private_ip}) 
  key_name               = local.keyname
  depends_on             = [aws_instance.master]
  vpc_security_group_ids = [aws_security_group.k3s-worker-sec-group.id]
  tags = {
    Name = "worker"
  }
}

resource "aws_security_group" "k3s-master-sec-group" {
  name = "k3s-master-sec-group"
  tags = {
    Name = "k3s-master-sec-group"
  }

  ingress {
    from_port = 30000
    protocol  = "tcp"
    to_port   = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    protocol  = "tcp"
    to_port   = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "k3s-worker-sec-group" {
  name = "k3s-worker-sec-group"
  tags = {
    Name = "k3s-worker-sec-group"
  }

  ingress {
    from_port = 30000
    protocol  = "tcp"
    to_port   = 32767
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #should be from within 
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

