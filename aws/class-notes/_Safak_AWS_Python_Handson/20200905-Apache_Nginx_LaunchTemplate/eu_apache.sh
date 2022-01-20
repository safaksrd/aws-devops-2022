Ozet: 2020-09-05

launch template icin kullanilan userdata:

#!/bin/bash

yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd



# Hands-on EC2-01 : How to Install Apache Web Server on EC2 Linux 2

## Outline

- Part 1 - Getting to know the Apache Web Server

- Part 2 - Launching an Amazon Linux 2 EC2 instance and Connect with SSH

- Part 3 - Installing and Configuring Apache Web Server to Run `Hello World` Page

- Part 4 - Automation of Web Server Installation through Bash Script

## Part 1 - Getting to know the Apache Web Server

![Apache HTTP Server](./apache-web-server.png)

The Apache HTTP Server, known as Apache, is a free and open-source cross-platform web server software, which is developed and maintained by an open community of developers under the auspices of the Apache Software Foundation.

## Part 2 - Launching an Amazon Linux 2 EC2 instance and Connect with SSH

1. Launch an Amazon EC2 instance with AMI as `Amazon Linux 2`, instance type as `t2.micro` and default VPC security group which allows connections from anywhere and any port.

2. Connect to your instance with SSH.


ssh -i .....pem ec2-user@

Not: Anahtarimiz adi h.pem olsun 

ilk acildiginda h.pem anahtari 777 (-rwxrwxrwx) yani herkes tarafindan okunur degistirilir, yazılır modda.
Bu modu degistirmeden baglanmaya calisirsak asagidaki hatayi verir.

Permissions 0777 for 'first.pem' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "first.pem": bad permissions

pem e okuma yetkisi verilmesi gerekiyor.
chmod 400 .....pem

Not: Windowsta yasanan sorun hakkinda;
Bu asamada chmod 400 ..pem yapmama ragmen mod 555 oldu. Hangi shell ile denediysem de sorun cozulmedi. 
Timothy hoca ile sorunu soyle cozduk. cd ile kök dizine gecis yaptik, 
ls -a ile baktik, .ssh dosyasinin icinde anahtar olmadigini gorunce, terminalden explerer.exe . komutu ile 
.ssh klasorune Windows ortaminda gecis yaptik, sonra buraya keyi yapistirdik. 
Ardindan keyin yetkisini chmod 400 ile degistirdik.

## Part 3 - Installing and Configuring Apache Web Server to Run `Hello World` Page

# STEP_1

3. Update the installed packages and package cache on your instance.

sudo yum update -y


4. Install the Apache Web Server-default page

sudo yum install httpd -y


5. Start the Apache Web Server.


sudo systemctl start httpd


6. Check status of the Apache Web Server.


sudo systemctl status httpd

7. Enable the Apache Web Server to survive the restarts 
then Check from browser with DNS

sudo systemctl enable httpd

Not: Isntance ı stop ettikten sonra tekrar strat edince de calismasi icin.

8. Set permission of the files and folders under `/var/www/html/` folder to everyone.


sudo chmod -R 777 /var/www/html # -R:rekursive, ice dogru uygular

Not:Recursive olarak icine konan dosyalara da uyguluyor.

9. Go to the /var/www/html

cd /var/www/html

10. Create a custom `index.html` file under `/var/www/html/` folder to be served on the Server.

echo "merhaba clarusway" > /var/www/html/index.html #bu tehlikeli bir komut, her ne varsa silip yeniden yaziyor. 
echo "iyi aksamlar herkese" >> /var/www/html/index.html #bu ise varolanin uzerine yaziyor.

11. check the index.html
ls 
cat index.html

12. Restart the httpd server and `check` from browser

sudo systemctl restart httpd

# STEP_2-HTML format

13. open index.html  file with vim editor.

cd /var/www/html
vim index.html

press I

14. clean the existing messsage then paste the html formatted code.

<html>
<head>
    <title> My First Web Server</title>
</head>
<body>
    <h1>Hello to Everyone from My First Web Server</h1>
</body>
</html>

15. Save and exit and show with cat command

ESC :wq
cat index.html

16. Restart the Apache Web Server.

sudo systemctl restart httpd

17. Check if the Web Server is working properly from the browser.

## Part 4 - Automation of Web Server Installation through Bash Script

18. Configure an Amazon EC2 instance with AMI as `Amazon Linux 2`, instance type as `t2.micro`, default VPC security group which allows connections from anywhere and any port.

19. Configure instance to automate web server installation with `user data` script.
Not: Asagidaki komutlar user dataya yazildigi icin sudo kullanmaya gerek yok

```bash
#! /bin/bash

#update os
yum update -y
#install apache server
yum install httpd -y
# get date and time of server
DATE_TIME=`date`
# create a custom index.html file
echo "<html>
<head>
    <title> My First Web Server</title>
</head>
<body>
    <h1>Hello to Everyone from My First Web Server</h1>
    <p>This instance is created at <b>$DATE_TIME</b></p>
</body>
</html>" > /var/www/html/index.html
# start apache server
systemctl start httpd
systemctl enable httpd
```

20. Review and launch the EC2 Instance

21. Once Instance is on, check if the Apache Web Server is working from the web browser.

22. Connect the Apache Web Server from the local terminal with `curl` command.


curl http://ec2-3-15-183-78.us-east-2.compute.amazonaws.com8.us-east-2.compute.amazonaws.com

Not: Terminalde curl http://...... yazilirsa web sayfasinin icini terminalde goruruz.