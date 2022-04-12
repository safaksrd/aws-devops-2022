#!/bin/bash
yum update -y
yum install python3 -y
pip3 install flask
cd /home/ec2-user
wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200930-001-roman-numerals-converter/app.py
mkdir templates
cd templates
wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200930-001-roman-numerals-converter/templates/index.html
wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200930-001-roman-numerals-converter/templates/result.html
python3 /home/ec2-user/app.py