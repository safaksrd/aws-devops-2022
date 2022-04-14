terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  mytag = "leon"
}

data "aws_ami" "tf_ami1" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "tf-ec2-1" {
  ami           = data.aws_ami.tf_ami1.id
  instance_type = var.ec2_type
  key_name      = var.ec2_key_name
  tags = {
    Name = "${local.mytag}-this is from my_ami"
  }
}

data "aws_ami" "tf_ami2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220218.3-x86_64-gp2"]
  }
}

resource "aws_instance" "tf-ec2-2" {
  ami           = data.aws_ami.tf_ami2.id
  instance_type = var.ec2_type
  key_name      = var.ec2_key_name
  tags = {
    Name = "${local.mytag}-this is from amazon linux2 ami"
  }
}