# Part 2 - Connecting and Configuring MariaDB Database

# Connect to the MariaDB Server and open MySQL CLI with root user, no password set as default.
`root user olarak MariaDB database ine baglaniyoruz. 
 MariaDB MySQL kokenli oldugu icin mysql komutlari kullaniliyor. Diger database lerde de gecerli olabilirmis`
mysql -u root

# Suan MAriaDB server CLI icindeyiz
# Show default databases in the MariaDB Server.
`test database i MariaDB yi yazanlar denemeler yapilsin diye koymus`
`MariaDB [(none)] burada none yazmasinin sebebi halihazirda database secmedigimiz icin`
SHOW DATABASES;

# Choose a database (mysql db) to work with. ⚠️ Caution: We have chosen mysql db as demo purposes, normally database mysql is used by server itself, it shouldn't be changed or altered by the user.
`USE mysql dersek none MariaDB [mysql] seklinde degisecek, mysql db ye girdik`
USE mysql;

# Show tables within the mysql db.
SHOW TABLES;

# Show users defined in the db server currently.
`user tablosundan 3 tane kolonu süzüyoruz`
SELECT Host, User, Password FROM user; #SELECT * dersek  karmakaridik bir sürü bilgi geliyor, biz sadece host, user ve password u gormek istedigimiz icin boyle yazariz

#Close the mysql terminal.
EXIT;

# Setup secure installation of MariaDB.
# No root password for root so 'Enter' for first question,
# Then set root password: 'root1234' and yes 'y' to all remaining ones.
sudo mysql_secure_installation

`Remove anonymous users? [Y/n] y Anonymous user in baglanmasini istemiyoruz`
`Disallow root login remotely? [Y/n] y : root un uzaktan sifresiz baglanmasini istemiyoruz. mysql -u root ile degil mysql -u root -p ile baglanacagiz`
`Remove test database and access to it? [Y/n] y : deneme amacli olan test database i siliyoruz`
`Reload privilege tables now? [Y/n] y`

# Show that you can not log into mysql terminal without password anymore.
mysql -u root

#Connect to the MariaDB Server and open MySQL CLI with root user and password (pw:root1234).
mysql -u root -p

# Show that test db is gone.
SHOW DATABASES;

# List the users defined in the server and show that it has now password and its encrypted.
USE mysql;
SELECT Host, User, Password FROM user;
`Anonymous user silindi`

# Create new database named 'clarusdb'.
CREATE DATABASE clarusdb;

# Show newly created database.
SHOW DATABASES;

# Create a user named 'clarususer'.
CREATE USER clarususer IDENTIFIED BY 'clarus1234';
'passwordu: clarus1234 olan clarususer olusturduk'

# Grant permissions to the user clarususer for database clarusdb.
GRANT ALL ON clarusdb.* TO clarususer IDENTIFIED BY 'clarus1234';
'clarusdb haricindeki databaseleri goremeyecek'

# Update privileges.
FLUSH PRIVILEGES;

# Close the mysql terminal.
EXIT;