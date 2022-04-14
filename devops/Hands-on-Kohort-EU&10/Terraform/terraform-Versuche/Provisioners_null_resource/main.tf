terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0" # 4.0 dan yuksek versiyonlarda calisir
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance" {
  ami             = "ami-0c02fb55956c7d316"
  instance_type   = "t2.micro"
  key_name        = "leon"
  security_groups = ["tf-provisioner-sg-nullresource"] # default VPC de kullaniyorsak bu kolay gosterim
  # vpc_security_group_ids = aws_security_group.tf-sec-gr.id # baska VPC de olsaydik bu tarz bir gosterim olurmus, tabi asagidaki security group blogunda da eklemeler olur
  tags = {
    Name = "terraform-instance-with-provisioner_nullresource"
  }
}

# provisioner normalde ilgili resource un icinde tanimlanir. Bir baska yol ise null resource kullanmaktir
# null resource un guzel yani conenction bu blogun icinde yer aldigi icin, baglantida sorun olsa bile yukaridaki altyapi olusmasina engel olmaz
resource "null_resource" "name" {
  
  provisioner "local-exec" { # terraform a lokaldeki makinenin terminalinde islem yaptirirken local-exec kullanilir
    command = "echo http://${aws_instance.instance.public_ip} > public_ip.txt"
    # self=aws_instance.instance yazilabilir. Ama ayni blogun icinde oldugumuz icin self kisa gosterim.
    # ${} yerine direk kullanim yayginlasmis.
  }

  connection { # remote-exec ve file provisioner icin connection gerekli. lokalde connection bloguna gerek yok
    host        = aws_instance.instance.public_ip
    type        = "ssh" # windows makinelerde winrm yazilir
    user        = "ec2-user"
    private_key = file("~//key/leon.pem") # file kmutu ile key imizi gosteriyoruz
  }

  provisioner "remote-exec" { # terraform a remote makinenin terminalinde islem yaptirirken remote-exec kullanilir
    inline = [
      "sudo yum -y install httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
    ]
  }

  provisioner "file" {           # source-destination ikilisi ile lokal makinemdeki bir bilgiyi yeni olusam resource a gonderebilirim
    content     = aws_instance.instance.public_ip # burada content-destination ikilisi kullanarak olusan instance in ip sini instance in icine yazdirdik
    destination = "/home/ec2-user/my_public_ip.txt"
  }
}

resource "aws_security_group" "tf-sec-gr-nullresource" {
  name = "tf-provisioner-sg-nullresource"
  tags = {
    Name = "tf-provisioner-sg-leon-nullresource"
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
