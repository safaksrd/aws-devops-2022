#!/bin/bash
  yum update -y
  yum install httpd -y
  DATE_TIME=`date`
  echo "<html>
  <head>
      <title> My First Web Server</title>
  </head>
  <body>
      <h1>Hello to Everyone from My First Web Server</h1>
      <p>This instance is created by Safak at <b>$DATE_TIME</b></p>
  </body>
  </html>" > /var/www/html/index.html
  systemctl start httpd
  systemctl enable httpd
 