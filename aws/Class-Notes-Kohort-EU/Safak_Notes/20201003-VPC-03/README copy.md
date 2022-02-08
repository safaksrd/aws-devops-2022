Ozet: 2020-10-03
Yeni repoya uygun sekilde guncellendi!!

NOT: Handson un Peering ile ilgili mimarisi VPC Peering Windows-EC2.png isimli resimdeki gibidir. VPC-03.pdf in ilk sayfasindaki mimaride Bastion Host da sanki kullaniliyor gibi görünüyor, halbuki Bastion Host a gerek yok

NOT: Handson un Endpoint ile ilgili mimarisi VPC Endpoint S3-EC2.png isimli resimdeki gibidir. VPC-03.pdf in 4. sayfasindaki mimaride NAT Gateway kullanilmiyor gibi görünüyor, halbuki

- S3 global bir servisdir, VPC ler üstü bir servistir.

- Endpoint: Klasik yontemde VPC ler uzeri bir servis olan yani global ortamda duran S3 servisine ulasmak icin Private subnetten once NAT Gateway (yada NAT Instance) den cikip ve sonrasinda Internet Gateway den internete cikip internette dolasip S3 e ulasiyorduk. Halbuki S3 ayni AWS networkunun icinde, bunca zahmete gerek yok, AWS network u icinde bir shortcut (Endpoint) ile yan odadaki S3 e baglanabiliriz. Bu S3 de olabilir bir database de olabilir.

- Endpoint ile ilgili handson da once Endpoint kullanmadan public subnette kurulan Bastion Host dan Web sayfasinin kurulu oldugu Private subnette kurulu EC2 instance a gireriz, ordan NAT Gateway ile internete cikariz, internette dolasir S3 e gireriz. Endpoint oldugunda ise internete cikmaya gerek olmaz, AWS networkunden ayrilmadan S3 e direk gireriz. Endpoint olusturunca Route Table a otomatik eklenir.

- VPC Peering: Klasik yöntemde bir VPC deki public subnetten cikip baska bir VPC deki public subnete ulasmak icin, ilk VPC nin Internet Gateway inden internete cikip, interneti dolasip, diger VPC nin Internet Gateway inden onun icine girmek gerekiyordu. Halbuki her iki VPC de ayni AWS networkunun icinde, bunca zahmete gerek yok, AWS netwotk u icinde bir VPC Peering ile yan mahalledeki VPC ye tüp gecitle baglanabiliriz. VPC Peering sadece ilgili iki VPC arasinda yol aciyor. Elimizde 3 VPC olsun, 1. VPC ile 2. ve 3. VPC ler arasinda Peering kurarasak bu 2. ve 3. VPC nin kendi aralarinda baglanabilecegi anlamina gelmiyor.

- VPC Peering ile ilgili handson da AWS nin sundugu Default VPC de yer alan bir public subnete Windows AMI kurduk. Bu subnet ile ayni regionda yer alacak sekilde (ornegin us-east-1a, bunu hizli olmasi ve daha az ucret odemek icin yapiyoruz) kendi olusturdugumuz VPC de bir NAT Gateway olusturduk. Bu NAT Gateway i kendi olusturdugumuz VPC de yer alan Private subnetlerin Route Table ina Outband Connectivity saglamak icin yazdik. Kendi olusturdugumuz VPC de Private Subnette ama hiz ve ücret acisindan Windows AMI ile ayni subnette yer alacak sekilde bir Linux EC2 instance i User Datali kurduk (KEN RYU web sayfasini icerecek sekilde bir NginX Web server). Default VPC ile kendi olusturdugumuz VPC arasina VPC Peering kurduk, Sonra her iki VPC nin Route Tables ina birbirlerinin CIDR bloklarini Destination olarak ekledik. Artik Default VPC de public subnette kurulu Windows makineden kendi olusturdugumuz VPC nin private subnetinde kurulu KEN RYU websayfasina AWS networku üzerinden baglanabiliriz.

- NACL Subnetler icin, Security Group ise Resources icin (z.B. EC2 Instance) olusturulur. 
- Dolayisiyla Subnetler NACL Rules u uygular, EC2 Instances hem NACL hem de Security Group Rules u uygular.
- NACL sistenin girisindeki güvenlik, Security Group binanin girisindeki güvenliktir.
- NACL rules hiyerarsik sirayla uygulanir. Security Groups da bu yoktur.
- NACL da Allow/Deny secebiliyoruz, Security Groups da sadece Allow seciliyor.
- NACL stateless dir, Security Groups stateful dur. Yani NACL da Inbound ve Outbound Rules ayri ayri ayarlanir. NACL Rules kapsaminda EC2 Instance a girdigin porttan disari cikamazsin. Outbound Rules icin 1024-65535 arasindaki Ephemeral Ports kullanilir. Ornegin HTTP 80 porttan EC2 Instance a giriyorsa, EC2 Instance dan cikis icin 1024-65535 arasi secilmelidir.
- Subnetlere birden fazla NACL atayamayiz ancak bir NACL i birden fazla Subnete atayabiliriz.


- Migration faaliyetleri kapsaminda AWS firmalara on premise leri AWS ile hibrit sekilde kullanmalari ve yavas yavas pacayi kapip komple AWS ye tasimak icin sundugu yontemler var.
1) AWS VPN : Internet aracaligi ile firmanin on premise deki resource lari ile AWS deki resource larini baglar.
  1.a. AWS Site to Site VPN : On Premise Data Center ile AWS arasina koyariz.
  1.b. Amazon Client VPN : Remote calisan firma elemani VPN ile once AWS ye girer, sonra AWS uzerinden internete ya da on premise deki data center resource lara ulasir. Bu su anlama geliyor, demekki AWS ile On Premise Data Center arasinda hali hazirda Site to Site VPN kurulu.

2) Direct Connect : Firma ile AWS arasina ya da AWS nin EDGE deki taseronu arasina fiber kablo ile baglanti yapilir. Dolayisiyla VPN deki gibi internete cikmaya gerek kalmaz. AWS networku icinde kalarak daha hizli daha guvenli baglanti saglanir.



# Hands-on VPC-03 : 

## Part 5 - Creating VPC peering between two VPCs (Default and Custom one)

## STEP 1 : Prep---> Launching Instances


- Launch two Instances. First instance will be in "clarus-az1a-private-subnet" of "clarus-vpc-a",and the other one will be in your "Default VPC". 

- In addition, since the private EC2 needs internet connectivity to set user data, we also need NAT Gateway.

### A. Configure Public Windows instance in **Default VPC.

```text
AMI             : Microsoft Windows Server 2019 Base
Instance Type   : t2.micro
Network         : **Default VPC
Subnet          : Default Public Subnet
Security Group  : 
    Sec.Group Name : WindowsSecGrb
    Rules          : RDP --- > 3389 ---> Anywhere
Tag             :
    Key         : Name
    Value       : Windows public

PS: For MAC, "Microsoft Remote Desktop" program should be installed on the computer.
```
### B. Since we need http connection we need to change Private Sec.Grb.

Security Group    : 
    Sec.Group Name : Private Sec.group
    Rules          : All Traffic ---> 0.0.0.0.0/0   # Bir onceki handson dan private Sec Group un inbound rules unda SSH TCP 22 portu acikti, ve Guile hoca ile Source u custom secip Public Sec Group u secmistik, Ancak EC2 Instance a HTTP / HTTPS den ulasmak icin HTTP / HTTPS portlarini anywhere seklinde acmaliyiz. Portlar ile ayri ayri acmaya ugrasmadan All Traffic Source Anywhere 0.0.0.0.0/0 secebliriz. All Traffic-Anywhere yerine HTTP portu-Windows makinenin private IP sini girmek de KEN-RYU websayfasini gormek icin yeterli olacaktir. Hem sadece Windows makineyi adreslemis baskalarinin girmesini engellemis oluruz. 
    
### C. Since the private EC2 needs internet connectivity to set user data, we use NAT Gateway

- Click Create Nat Gateway button in left hand pane on VPC menu

- click Create NAT Gateway.

```bash
Name                      : clarus-nat-gateway-2

Subnet                    : clarus-az1a-public-subnet

Elastic IP allocation ID  : Second Elastic IP
```
- click "Create Nat Gateway" button

### D. Modify Route Table of Private Instance's Subnet

- Go to VPC console on left hand menu and select Route Table tab

- Select "clarus-private-rt" ---> Routes ----> Edit Rule ---> Add Route
```
Destination     : 0.0.0.0/0
Target ----> Nat Gateway ----> clarus-nat-gateway-2
```
- click save routes

WARNING!!! ---> Be sure that NAT Gateway is in active status. Since the private EC2 needs internet connectivity to set user data, NAT Gateway must be ready.

### E. Configure Private instance in 'clarus-az1a-private-subnet' of 
'clarus-vpc-a'.

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a 
Subnet          : clarus-az1a-private-subnet
user data       : 

#!/bin/bash

yum update -y
amazon-linux-extras install nginx1.12
yum install -y wget
chkconfig nginx on
cd /usr/share/nginx/html
chmod o+w /usr/share/nginx/html
rm index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/ken.jpg
service nginx start

Security Group    : 
    Sec.Group Name : Private Sec.group
    Rules          : All Traffic ---> 0.0.0.0.0/0   # Bir onceki handson dan private Sec Group un inbound rules unda SSH TCP 22 portu acikti, ve Guile hoca ile Source u custom secip Public Sec Group u secmistik, Ancak EC2 Instance a HTTP / HTTPS den ulasmak icin HTTP / HTTPS portlarini anywhere seklinde acmaliyiz. Portlar ile ayri ayri acmaya ugrasmadan All Traffic Source Anywhere 0.0.0.0.0/0 secebliriz. All Traffic-Anywhere yerine HTTP portu-Windows makinenin private IP sini girmek de KEN-RYU websayfasini gormek icin yeterli olacaktir. Hem sadece Windows makineyi adreslemis baskalarinin girmesini engellemis oluruz. 

Tag             :
    Key         : Name
    Value       : Private WEB EC2 

```

- Go to instance named 'Windows public' and push the connect button ----> Download Remote Desktop File

- Decrypt your ".pem key" using "Get Password" button
  - Push "Get Password" button
  - Select your pem key using "Choose File" button ----> Push "Decrypt Password" button
  - copy your Password and paste it "Windows Remote Desktop" program as a "administrator password"

- Open the internet explorer of windows machine and paste the private IP of EC2 named 'Private EC2 for peering'

- It is not able to connect to the website 


## STEP 2: Setting up Peering


- Go to 'Peering connections' menu on the left hand side pane of VPC

- Push "Create Peering Connection" button

```text
Peering connection name tag : First Peering
VPC(Requester)              : Default VPC
Account                     : My Account
Region                      : This Region (us-east-1)
VPC (Accepter)              : Clarus-vpc-a
```
- Hit "Create peering connection" button

- Select 'First Peering' ----> Action ---> Accept Request ----> Accept Request

- Go to route Tables and select default VPC's route table ----> Routes ----> Edit routes
```
Destination: paste "clarus-vpc-a" CIDR blok
Target ---> peering connection ---> select 'First Peering' ---> Save routes
```

- select clarus-private-rt's route table ----> Routes ----> 
Edit routes
```
Destination: paste "default VPC" CIDR blok
Target ---> peering connection ---> select 'First Peering' ---> Save routes
```

- Go to windows EC2 named 'Windows public', write IP address on browser and show them to website with KEN..


WARNING!!! ---> Please do not terminate "NAT Gateway" and "Private WEB EC2" for next part.


## Part 6 - Create VPC Endpoint

# STEP 1: Prep : Nginx kurulu instance in bagli oldugu SecGorup u Guile hocadaki haline geri ceviriyoruz.

Security Group    : 
    Sec.Group Name : Private Sec.group
    Rules          : All Traffic ---> Custom - Public Sec.Grb


### A. Create S3 Bucket 

- Go to the S3 service on AWS console
- Create a bucket of `clarusway-vpc-endpoint` with following properties, 

```text
Versioning                  : Disabled
Server access logging       : Disabled
Tagging                     : 0 Tags
Object-level logging        : Disabled
Default encryption          : None
CloudWatch request metrics  : Disabled
Object lock                 : Disabled
Block all public access     : unchecked
```
- upload 'Guile.png' and 'Honda.png' files into the S3 bucket

### B. Configure Public Instance (Bastion Host)

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1b-public-subnet
Security Group  : 
    Sec.Group Name : Public Sec.Group
    Rules          : TCP --- > 22 ---> Anywhere
                     All ICMP IPv4  ---> Anywhere
                     HTTp--------> Anywhere
Tag             :
    Key         : Name
    Value       : Public EC2 (Bastion Host)
```

### C. Create IAM role to reach S3 from "Private WEB EC2"

- Normalde CLI den Role olmadan iki resource birbirine ulasabilir ama konsolda Role lazim
- Go to IAM Service from AWS console and select roles on left hand pane

- click create role
```
use case : EC2 ---> Next : Permission
Policy ---> "AmazonS3FullAccess" ---> Next
Role Name : clarusS3FullAccessforEndpoint
Role Description: clarus S3 Full Access for Endpoint
click create button
```
Go to EC2 service from AWS console

Select "Private WEB EC2" ---> Actions ---> Instance Settings ---> Attach/Replace IAM Role select newly created IAM role named 'clarusS3FullAccessforEndpoint' ---> Apply

# STEP 2: Connect S3 Bucket from Private WEB Instance

### A. Connect to the Bastion host

- Go to terminal and connect to the Bastion host named 'Public EC2 (Bastion Host)'

- Using Bastion host connect to the EC2 instance in "private subnet" named 'Private WEB EC2 ' (using ssh agent or copying directly pem key into the EC2)

- go to your local terminal

- add your private key to the ssh agent on your localhost
```bash
ssh-add ./[your pem file name]
```
- run the ssh agent if it is returning error like "Could not open a connection to your authentication agent"
```bash
eval "$(ssh-agent)"
```
-  try again to add your private key to the ssh agent
```bash
ssh-add ./[your pem file name]
```
- connect to the ec2-in-az1a-public-sn instance in public subnet
```bash
ssh -A ec2-user@ec2-3-88-199-43.compute-1.amazonaws.com
```
### B.Connect to the Private Instance

- once logged into the bastion host connect to 
the private instance in the private subnet:
```bash
ssh ec2-user@[Your private EC2 private IP]
```
### C. Use CLI to verify connectivity

- list the bucket in S3 and content of S3 bucket named "aws s3 ls "clarusway-vpc-endpoint" via following command

```
aws s3 ls
aws s3 ls clarusway-vpc-endpoint
```
- go to private route table named "clarus-private-rt" on VPC service

- select routes sub-menu ---> Edit routes ---> Delete "Peering and NAT Gateway"

- Go to the terminal and try to connect again S3 bucket via following command
```
aws s3 ls
```
- show that you are "not able to connect" to the s3 buckets list


## STEP 3: Create Endpoint

### A. Connect to S3 via Endpoint

- go to the Endpoints menu on left hand pane in VPC

- click Create Endpoint
```text
Service Category : AWS services
Service Name     : com.amazonaws.us-east-1.s3
VPC              : clarus-vpc-a
Route Table      : choose private one or both 
```
- Create Endpoint

- Go to private route table named 'clarus-private-rt' and show the endpoint rule that is automatically created by AWS 

### B. Connect  to S3 via Endpoint

- Go to terminal, list the buckets in S3 and content of S3 bucket named "aws s3 ls 
"clarusway-vpc-endpoint" via following command
```bash
aws s3 ls
aws s3 ls clarusway-vpc-endpoint
```

- copy the 'Guile.png' and 'Honda.png' files from S3 bucket into the private EC2
```bash
aws s3 cp s3://clarusway-vpc-endpoint/Guile.png .
aws s3 cp s3://clarusway-vpc-endpoint/Honda.png .
```

## Part 7 - Configuring NACL

## Step 1 :

- Go to the 'Network ACLs' menu from left hand pane on VPC

- click 'Create Network ACL' button
```
Name Tag      :clarus-private1a-nacl
VPC           :clarus-vpc-a
```
- Select Inbound Rules ---> Edit Inbound rules ---> Add Rule
```text
  Rule        Type              Protocol      Port Range        Source      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0   Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0   Allow
```

- Select Outbound Rules ---> Edit Inbound rules ---> Add Rule
```text
  Rule        Type              Protocol      Port Range        Destination      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Deny
```

- In the  NACL menu, select Subnet associations sub-menu ---> Edit subnet association ---> select "clarus-az1a-private-subnet" ---> edit

## Step 2 :

- go to terminal and try to connect the private EC2 with bastion host and show that there is no connectivity with ssh ---> explain ephemeral port

- go to your local terminal

- add your private key to the ssh agent on your localhost
```bash
ssh-add ./[your pem file name]
```
- run the ssh agent if it is returning error like "Could not open a connection to your authentication agent"
```bash
eval "$(ssh-agent)"
```
-  try again to add your private key to the ssh agent
```bash
ssh-add ./[your pem file name]
```
- connect to the ec2-in-az1a-public-sn instance in public subnet
```bash
ssh -A ec2-user@ec2-3-88-199-43.compute-1.amazonaws.com
```
- once logged into the bastion host connect to 
the private instance in the private subnet:
```bash
ssh ec2-user@[Your private EC2 private IP]
```
## Step 3 :

- using ping command, try to ping private EC2
```bash
ping [private EC2 Ip Address]
```

- go to the NACL table named "clarus-private1a-nacl"

- Select Outbound Rules ---> Edit Inbound rules ---> Add Rule

```text
  Rule        Type              Protocol      Port Range        Destination      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Deny 
  |                                         |                                   |
  |                                         |                                   |
  V                                         V                                   V
  100         Custom TCP Rule   TCP(6)      ""32768 - 65535""   0.0.0.0/0          Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         ""Allow""
```
- click save, go to the terminal and reconnect to the private EC2

- using ping command, try to ping again to the private EC2
```bash
ping [private EC2 Ip Address]
```















