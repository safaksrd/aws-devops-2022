#!/bin/bash
yum update -y
amazon-linux-extras install nginx1.12
systemctl enable nginx
cd /usr/share/nginx/html
chmod o+w /usr/share/nginx/html 
rm index.html
wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200916-101-kittens-carousel-static-website-ec2/proje-101/static-web/index.html
wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200916-101-kittens-carousel-static-website-ec2/proje-101/static-web/cat0.jpg
wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200916-101-kittens-carousel-static-website-ec2/proje-101/static-web/cat1.jpg
wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200916-101-kittens-carousel-static-website-ec2/proje-101/static-web/cat2.jpg
systemctl start nginx
 