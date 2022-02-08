# Part 4 - Creating a Client Instance and Connecting to MariaDB Server Instance Remotely
'Ubuntu ile yeni bir EC2 instance olusturduk, uzerine MariaDB client kuracagiz ve '
'MariaDB Database Server kurulu olan diger EC2 instance a baglanip DATABASE, TABLES kontrolleri yapacagiz'
'ssh -i yerine mysql -h ile client dan server a baglaniyoruz'

# Launch EC2 Instance (Ubuntu 20.04) and name it as MariaDB-Client on Ubuntu.
ssh- i xxx.pem ubuntu@IPaddress
# AMI: Ubuntu 20.04
# Instance Type: t2.micro
# Security Group
#   - SSH           -----> 22    -----> Anywhere
#   - MYSQL/Aurora  -----> 3306  -----> Anywhere

# Connect to EC2 instance with SSH.

# Update instance. Bu kodlari alt alta da irebilirsin
sudo apt update && sudo apt upgrade -y

# Install the mariadb-client.
# MariaDB Client MariaDB server a Uzaktan baglanmamizi saglar
sudo apt-get install mariadb-client -y

# Connect the clarusdb on MariaDB Server on the other EC2 instance (pw:clarus1234). MariaDB Server kurulu olan (Linux kurulu) instance in IP si girilecek
mysql -h 54.89.63.211 -u clarususer -p # h harfi ile hostname i belirliyoruz

# Show that clarususer can do same db operations on MariaDB Server instance.
SHOW DATABASES;
USE clarusdb;
SHOW TABLES;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT first_name, last_name, salary, city, state FROM employees INNER JOIN offices ON employees.office_id=offices.office_id WHERE employees.salary > 100000;

# Close the mysql terminal.
EXIT;

# DO NOT FORGET TO TERMINATE THE INSTANCES YOU CREATED!!!!!!!!!!