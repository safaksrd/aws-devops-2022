terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "tf-mainsecgr" {
  name        = "tf-main-sec-gr"
  description = "Allow SSH, HTTPS, HTTPS inbound traffic"
  tags = {
    Name = "Leon-tf-main-sec-gr"
  }

  dynamic "ingress" {
    for_each = var.secgr-dynamic-ports # variable yukarida tanimli. variable "secgr-dynamic-ports" 
    content {
      from_port   = ingress.value # "secgr-dynamic-ports" variable in [22,80,443] degerleri sirayla value olarak giriliyor
      to_port     = ingress.value # "secgr-dynamic-ports" variable in [22,80,443] degerleri sirayla value olarak giriliyor
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}