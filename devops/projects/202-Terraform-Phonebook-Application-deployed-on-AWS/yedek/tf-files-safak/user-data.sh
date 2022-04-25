#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
yum install git -y

MyDB="db-endpoint" 
echo "${MyDB}" > /home/ec2-user/phonebook/dbserver.endpoint


# echo "$aws_db_instance.db-server.address" > /home/ec2-user/dbserver.endpoint 
# echo "${aws_db_instance.db-server.address}" oldugunda cevap cat dbserver.endpoint -> .db-server.address
# echo "$aws_db_instance.db-server.address" oldugunda cevap cat dbserver.endpoint -> .db-server.address
# echo "$[aws_db_instance.db-server.address]" oldugunda cevap cat dbserver.endpoint -> cevap bos

TOKEN="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"
FOLDER="https://$TOKEN@raw.githubusercontent.com/safaksrd/aws-devops-2022/main/devops/projects/202-Terraform-Phonebook-Application-deployed-on-AWS/phonebook/"
wget -P /home/ec2-user/phonebook "$FOLDER"phonebook-app.py
#wget -P /home/ec2-user/phonebook "$FOLDER"dbserver.endpoint #repoma gonderebilsem bu sekilde cekecegim ancak repoya nasil gonderecegimi bilmiyorum
wget -P /home/ec2-user/phonebook/templates "$FOLDER"templates/index.html
wget -P /home/ec2-user/phonebook/templates "$FOLDER"templates/add-update.html
wget -P /home/ec2-user/phonebook/templates "$FOLDER"templates/delete.html
python3 /home/ec2-user/phonebook-app.py