terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.11.0"
    }
    github = {
      source = "integrations/github"
      version = "4.23.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

provider "github" {
  # Configuration options
  token = "xxxx"
}
# Terraform aracaligi ile lokaldeki istedigimiz bilgileri githubda olusturacagiz
# Burada önemli olan su: Terraform da githuba push islemi yok!!
# Lokalde varolan dosyayi aliyor ayni isimle Github da olusturuyor
# Bunu 202-Phonebook Terraform projesindeki gibi github_repository_file resource u ile 
# her dosya icin ayri ayri resource tanimlayarak da Githubda olusturabiliriz
# (31-57.satirlari kullanmak yerine 70-82.satirlari kullandim)
# Birden fazla dosyayi tek seferde olusturmanin basit yolu ise for_each dongusu 
  
# resource "github_repository_file" "bookstore-api" {
#   content = file("bookstore-api.py") # lokalimdeki bilgiyi al
#   file = "bookstore-api.py" # github repoda icine koy
#   repository = github_repository.myrepo.name
#   branch = "main"
# }

# resource "github_repository_file" "requirements" {
#   content = file("requirements.txt") # lokalimdeki bilgiyi al
#   file = "requirements.txt" # github repoda icine koy
#   repository = github_repository.myrepo.name
#   branch = "main"
# }

# resource "github_repository_file" "Dockerfile" {
#   content = file("Dockerfile") # lokalimdeki bilgiyi al
#   file = "Dockerfile" # github repoda icine koy
#   repository = github_repository.myrepo.name
#   branch = "main"
# }

# resource "github_repository_file" "docker-compose" {
#   content = file("docker-compose.yml") # lokalimdeki bilgiyi al
#   file = "docker-compose.yml" # github repoda icine koy
#   repository = github_repository.myrepo.name
#   branch = "main"
# }

resource "github_repository" "myrepo" {
  name = "bookstore-repo-tf" # Github da olusturulacak olan reponun adi
  auto_init = true # reponun baslangic initialize icin, gerekli degil
  visibility = "private" # Github da olusturulacak olan reponun türü
}

resource "github_branch_default" "main" {
  branch = "main"
  repository = github_repository.myrepo.name
}

variable "files" {
  default = ["bookstore-api.py", "requirements.txt", "Dockerfile", "docker-compose.yml"] # isimleri lokalden gönderilecek isimlerle ayni olmak zorunda
}

resource "github_repository_file" "app-files" {
  for_each = toset(var.files)
  content = file(each.value)  # lokalimdeki belgelerin icindeki bilgiyi al
  file = each.value # github repoda ayni isimle olusturulan belgelerin icine koy
  repository = github_repository.myrepo.name
  branch = "main"
  commit_message = "managed by terraform"
  overwrite_on_create = true
}

resource "aws_instance" "tf-docker-ec2" {
  ami = "ami-0f9fc25dd2506cf6d"
  instance_type = "t2.micro"
  key_name = "leon"
  security_groups = ["docker-sec-gr-bookstore-tf"]
  tags = {
    Name = "Web Server of Bookstore"
  }

  user_data = <<-EOF
          #! /bin/bash
          yum update -y
          amazon-linux-extras install docker -y
          systemctl start docker
          systemctl enable docker
          usermod -a -G docker ec2-user
          curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
          -o /usr/local/bin/docker-compose
          chmod +x /usr/local/bin/docker-compose
          mkdir -p /home/ec2-user/bookstore-api
          TOKEN="xxxx"
          FOLDER="https://$TOKEN@raw.githubusercontent.com/safaksrd/bookstore-repo-tf/main/"
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/bookstore-api.py" -L "$FOLDER"bookstore-api.py
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/requirements.txt" -L "$FOLDER"requirements.txt
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/Dockerfile" -L "$FOLDER"Dockerfile
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/docker-compose.yml" -L "$FOLDER"docker-compose.yml
          cd /home/ec2-user/bookstore-api
          docker build -t safaksrd/bookstore:tf .
          docker-compose up -d
          EOF
# curl komutu sag taraftaki adresteki dosyayi bulur sol taraftaki adrese koyar  
  depends_on = [github_repository.myrepo, github_repository_file.app-files]
}



resource "aws_security_group" "tf-docker-sec-gr" {
  name = "docker-sec-gr-bookstore-tf"
  tags = {
    Name = "docker-sec-gr-bookstore-tf"
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "website" {
  value = "http://${aws_instance.tf-docker-ec2.public_dns}"

}