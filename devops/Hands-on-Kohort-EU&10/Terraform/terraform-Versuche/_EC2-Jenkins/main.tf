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

resource "aws_instance" "tf-ec2" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_type
  key_name        = var.ec2_key_name
  security_groups = ["tf-main-sec-gr"]
  tags = {
    "Name" = "${var.ec2_name}-instance" # linux de bir variable in sonuna bir sey ekleyeceksek ${}
  }

}
