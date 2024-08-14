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
  key_name               = local.key_name
  vpc_security_group_ids = [local.k3s_master_sec_group_id]
  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker" {
  ami                    = local.ami
  instance_type          = local.instancetype
  user_data              = templatefile("worker.sh", {master_node_private_ip = aws_instance.master.private_ip}) 
  key_name               = local.key_name
  depends_on             = [aws_instance.master]
  vpc_security_group_ids = [local.k3s_worker_sec_group_id]
  tags = {
    Name = "worker"
  }
}

