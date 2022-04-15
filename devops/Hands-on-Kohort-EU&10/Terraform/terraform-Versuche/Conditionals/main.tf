terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#
resource "aws_instance" "tf-instances" {
  ami = var.ec2_ami
  instance_type = var.ec2_type
  key_name = var.ec2_key_name
  count = var.ec2_number
  security_groups = ["tf-main-sec-gr"]
  tags = {
    Name = element(var.tf-tags, count.index ) # 4 farkli instance olustururken 4 makinenin TAG iini almak icin
  }
}