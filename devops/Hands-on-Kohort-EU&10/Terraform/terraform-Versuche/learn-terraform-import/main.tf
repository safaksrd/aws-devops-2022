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

# aws konsoldan olusturdugumuz security group u ayni bilgilerle daha sonra mudahele edebilmek icin buraya yaziyoruz
# aws de varolan security group u terminalden terraform import ile terraform yonetimine aliriz
# terraform registry de ilgili resource sayfasinin en alt kisminda import komutu var
# alttaki security group icin import komutu terraform import aws_security_group.tf-sg "security group id"
resource "aws_security_group" "tf-sg" {
  name = "tf-import-sg"
  description = "terraform import security group"
  tags = {
    Name = "tf-import-sg"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# liste icinden birsey sectirmek icin element fonksiyonunu kullaniriz
# aws instance icin import komutu terraform import aws_instance.tf-instance "id"
resource "aws_instance" "tf-instances" {
  ami = element(var.tf-ami, count.index ) # 3 farkli instance olustururken 3 makinenin AMI sini almak icin
  instance_type = "t2.micro"
  count = 3
  key_name = "leon"
  security_groups = ["tf-import-sg"]
  tags = {
    Name = element(var.tf-tags, count.index ) # 3 farkli instance olustururken 3 makinenin TAG iini almak icin
  }
}