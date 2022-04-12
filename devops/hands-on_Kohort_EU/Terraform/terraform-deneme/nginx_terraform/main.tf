provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

resource "aws_instance" "tf-ec2" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_type
  key_name        = var.ec2_key_name
  security_groups = ["tf-sec-gr-nginx"]
  tags = {
    "Name" = "${var.ec2_name}-instance" # linux de bir variable in sonuna bir sey ekleyeceksek ${}
  }
  user_data = file("./userdata.sh")
}

resource "aws_security_group" "tf-ec2-sec-gr" {
  name        = "tf-sec-gr-nginx"
  description = "allow ssh and http"
  tags = {
    "Name" = "leon-terraform-sec-gr"
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}





