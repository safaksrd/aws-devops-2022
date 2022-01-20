Ozet: 2020-09-24
- EC2 Instance uzerinde MariaDB Database Server ve bu server da tablolar olusturduk. Kullanici ayarlari yaptik.
- Sonra EC2 instance uzerinde MariaDB Client kurduk. EC2 Instance da kurulu olan Client dan baska bir EC2 Instance da kurulu olan Server a baglandik.
- MariaDB MySQL den fork edilmis bir database.


# Part 1 - Creating EC2 Instance and Installing MariaDB Server

# Launch EC2 Instance.

# AMI: Amazon Linux 2
# Instance Type: t2.micro
# Security Group
#   - SSH           -----> 22    -----> Anywhere
#   - MYSQL/Aurora  -----> 3306  -----> Anywhere

# Connect to EC2 instance with SSH.

# Update yum package management and install MariaDB server.
sudo yum update -y
sudo yum install mariadb-server -y

# Start MariaDB service.
sudo systemctl start mariadb

# Check status of MariaDB service.
sudo systemctl status mariadb

# Enable MariaDB service, so that MariaDB service will be activated on restarts.
sudo systemctl enable mariadb
