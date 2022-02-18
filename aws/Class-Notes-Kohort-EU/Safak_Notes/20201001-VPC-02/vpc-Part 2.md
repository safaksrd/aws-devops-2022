Ozet: 2020-10-01
Yeni repoya uygun sekilde guncellendi!!

- Elastic IP : Aslinda statik IP. 
- Bastion Host / Jump Box
- NAT Gateway
- NAT Instance
- Private Subnet icindeki bir Resource (z.B. EC2 Instance) disariya kapalidir. Buna disaridan ulasmanin yöntemi (Inbound Connectivity) Bastion Host (Jump Box), yani ayni VPC yer alan bir Public Subnet teki bir Resource u araci olarak kullanip Private Subnet teki Resource a ulasmaktir. 
- Public Subnetteki EC2 Instance dan Private Subnetteki EC2 Instance a ziplayabilmek icin, Private Subnet icindeki EC2 Instance i olustururken kullandigimiz key i Public Subnetteki EC2 Instance in icine tasiyip chmod 400 yapmayi unutma!
- Key i kullanmanin asagidaki gibi bir baska yolu daha var, aslinda bu yol best practice.
- eval "$(ssh-agent)" ve sonrasinda ssh-add ./[your pem file name] komutunu calistirinca bir agent olusuyor ve arka arkaya ne kadar EC2 ya baglansak da bu agent key i ilgili yerde bizim adimiza gosteriyor. 
- Dolayisiyla ssh -i key.pem ec-user@XXX yerine ssh -A ec-user@XXX yazarak instance a baglanabiliyoruz. VSCode dan her cikip girdigimizde eval islemi tekrarlanmali
- Private subnetteki EC2 Intance in Private IP si uzerinden Public subnetteki EC2 Instance in Private IP sine ping atabiliriz. Ancak Private subnetteki EC2 Intance dan internete ping atamayiz. Cozum NAT Gateway kullanmak.
- Private Subnet icindeki bir Resource (z.B. EC2 Instance) disariya kapalidir. Bu resource disariya yani internete vs baglanmak istediginde (Outbound Connectivity) NAT Gateway yontemi, yani ayni VPC yer alan bir Public Subnet te bir NAT Gateway kurmak ve bunu araci olarak kullanip Private Subnet teki Resource u disariya cikmasini saglamaktir.
- NAT Gateway AWS nin hazir bir Resource u. Elastik IP ye bagliyoruz o kadar. Tüm bakimi vs AWS de. Ucretli bir resource dur.
- NAT Instance i ise AWS nin NAT image indan biz bir EC2 Instance olusturuyoruz, tüm ayarlar ve bakim bize ait. Ucretlendirme EC2 Instance daki gibi.
- Private subnetteki EC2 Intance in internete cikabilmesi icin NAT Gateway yöntemini kullaniyorsak, elastik IP yi NAT Gateway e bagladiktan sonra Route Tables da Private Subnet ler icin olusturdugumuz Route Table'a local e ilaveten olusturdugumuz NAT Gateway i ekleriz. NAT Gateway Internete baglantiyi kesmek istedigimizde isimiz bittikten sonra NAT Gateway i silmeli ve ardindan Elastik IP'yi release etmeliyiz. Bunlari yapmazsak ucret kesmeye devam eder. NAT Gateway i silince Route Table a eklenen NAT Gateway in status ü Black hole olur. Bunu da sileriz.
- Son olarak NAT Gateway ile yaptigimizi NAT Instance ile yapacagiz. Community AMIs bölümünde nat ile search edip bir tane linux ami sec, ec2 Instance i kur, harddisk magnetic gelirse SSD sec. Bu yöntemde bütün sorumluluk bizde, instance in guncellenmesi bakimi, security group ayalarinin yapilmasi vs. Kurulumun ayrintilari asagidaki ilgili bölümdedir. Private subnetteki EC2 Intance in internete cikabilmesi icin NAT Instance yöntemini kullaniyorsak, Route Tables da Private Subnet ler icin olusturdugumuz Route Table'a local e ilaveten olusturdugumuz NAT Instance i ekleriz. 
- NAT Instance in Security Group unda ICMP port acik oldugu icin NAT Instance araciligi ile artik google.com a ping atabiliriz ancak herhangi bir sey indirip kurmak istiyorsak NAT Instance in Security Group unun inbound rules una HTTP ve HTTPS anywhere eklenir.
- NAT Instance da ayni zamanda bir Bastion Host dur. Isternise Bastion host olarak da kullanilabilir.
- NAT Instance ilk kuruldugunda yapilmasi gerekenler: Actions Menu -> Networking -> Enable Source/Destination Check -> Stop, Save et: NAT Instance a diyoruz ki Source check yapma, sana ne geliyorsa trafigi yonlendir anlamina geliyor.

## Part 2 - Creating Bastion Host and connect to the private subnet from internet

- discuss about how to connect to the "clarus-az1a-private-subnet" instance

- Explain logic of why we need Bastion Host?

- Launch two Instance. One is in Private Subnet-1a, the other one is in Public Subnet 1a

- Configure Public instance (Bastion Host).

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1a-public-subnet
Security Group  : 
    Sec.Group Name : Public Sec.group
    Rules          : TCP --- > 22 ---> Anywhere
                   : All ICMP IPv4  ---> Anywhere      # ping atabilmek icin bu portu actik 
Tag             :
    Key         : Name
    Value       : Public EC2 (Bastion Host)
```

- Configure Private instance.

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1a-private-subnet
Security Group  : 
    Sec.Group Name : Private Sec.group
    Rules          : TCP --- > 22 ---> Anywhere         # Daha guvenli olmasi icin Source bolumune Custom deyip yanindaki bosluga yeni olusturdugumuz public sec group u bulmasi icin pub yazariz ve ekleriz.
Tag             :
    Key         : Name
    Value       : Private EC2
```

- This configuration adds an extra layer of security and can also be used.
```text
Rules        : TCP --- > 22 ---> Anywhere
                |         |         |
                |         |         |
                V         V         V
               TCP --- > 22 ---> Public Sec.Group
``` 
- Try to connect private instance via ssh
  (As you see in the dashboard there is no public IP for instance)

- Since there is no public IP of private instance, we need to connect ssh via Bastion Host instance  
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
- once logged into the ec2-in-az1a-public-sn (bastion host/jump box), connect to 
the ec2-in-az1a-private-sn instance in the private subnet 
```bash
ssh ec2-user@[Your private EC2 private IP]
```
- Show connection of the private EC2 over the Bastion Host

### Part 3 - Creating NAT Gateway

-  discuss about how to connect to internet from the Private EC2 in private subnet 

Step 1 : Create Elastic IP

- Go to VPC console on left hand menu and select Elastic IP tab

- Tab Allocate Elastic IP address

Elastic IP address settings

```text
Network border Group : Keep it as is (us-east-1)

Amazon's pool of IPv4 addresses
```
- Click Allocate button and name it as "First Elastic IP"

- create a NAT Gateway in the public subnet

STEP 2: Create Nat Gateway

- Go to VPC console on left hand menu and select Nat Gateway tab

- Click Create Nat Gateway button 
```bash
Name                      : clarus-nat-gateway

Subnet                    : clarus-az1a-public-subnet

Elastic IP allocation ID  : First Elastic IP
```
- click "create Nat Gateway" button

STEP 3 : Modify Route Table of Private Instance's Subnet

- Go to VPC console on left hand menu and select Route Table tab

- Select "clarus-private-rt" ---> Routes ----> Edit Rule ---> Add Route
```
Destination     : 0.0.0.0/0
Target ----> Nat Gateway ----> clarus-nat-gateway
```
- click save routes

- go to private instance via terminal using bastion host

- try to ping www.google.com and show response.

- Go to VPC console on left hand menu and select Nat Gateway tab

- Select clarus-nat-gateway --- > Actions ---> delete Nat Gateway

- Go to VPC console on left hand menu and select Elastic IP tab

- Select "First Elastic IP" ----> Actions ----> Release Elastic IP Address ----> Release 

### Part 4 - Creating NAT Instance

STEP 1: Create NAT Instance

- Go to EC2 Menu Using AWS Console

```text
AMI             : ami-00a9d4a05375b2763 (Nat Instance) # Community AMIs da nat ile search yap
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1a-public-subnet
Security Group  : 
    Sec.Group Name : Public Sec.group
    Rules          : TCP ---> 22 ---> Anywhere
                   : All ICMP IPv4  ---> Anywhere

Tag             :
    Key         : Name
    Value       : Clarus NAT Instance
```

- Select created Nat Instance on EC2 list

- Tab Actions Menu ----> Networking ----> Enable Source/Destination Check ---> Stop, Save et
- NAT Instance a diyoruz ki Source check yapma, sana ne geliyorsa trafigi yonlendir anlamina geliyor.

- Explain why we need to implement this process mentioned above

STEP 2: Configuring the Route Table

- Go to Route Table and select "clarus-private-rt"

- Select Routes sub-menu ----> Edit Rules ----> Delete blackhole for Nat Gateway

- Add Route
```
Destination     : 0.0.0.0/0
Target ----> Instance ----> Nat Instance
```

- Connect to private Instance via bastion host and ping www.google.com to show response.

- NAT Instance in Security Group unda ICMP port acik oldugu icin NAT Instance araciligi ile artik google.com a ping atabiliriz ancak herhangi bir sey indirip kurmak istiyorsak NAT Instance in Security Group unun inbound rules una HTTP ve HTTPS anywhere eklenir.