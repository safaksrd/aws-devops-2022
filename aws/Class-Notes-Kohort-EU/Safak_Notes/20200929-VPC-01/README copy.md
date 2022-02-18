Ozet: 2020-09-29

- VPC: Ozel alan, ozelliklerini biz belirliyoruz. Ornegin bir firmanin binasini VPC olarak düsünelim.
- Subnet: VPC icindeki logical bölümlerdir. VPC icinde kümelendirme yapmak icin (finans, marketing vs.) subnet kullaniyoruz. Subnet, VPC nin kuruldugu Region altindaki farkli AZ lerde kurulabilir. Bu farkli AZ leri ayni firmaya ait farkli kampusler gibi dusunebiliriz.
- VPC icinde bölümlere dagitilabilecek dahili telefon hatlari CIDR dir. Dolayisi ile ayni CIDR baska bir VPC'de de kullanilabilir. 
- Public Subnet te yer alan birine dahili telefonun (CIDR) disinda, harici telefondan da ulasilabilir. Bu harici telefon Public IP dir. Dolayisiyla dahili telefon private IP, harici telefon public IP. 
- Private Subnet te yer alan birine ise sadece dahili telefon (CIDR) verilir. Bu kisiye dahili telefon haricinde ulasmanin bir baska yolu Bastion Host tur (Jump Box). Yani ayni VPC deki Public Subnet ten baska birine ulasip diyoruz ki private subnet teki su kisiye haber verir misin ona ulasmaya calisiyorum.
- lokal : ic hatlar terminali. VPC icinde dolasirken
- igw: Internet Gateway (IGW): Dis hatlar terminali. VPC disina cikacagimiz zaman. Bir VPC e sadece bir IGW eklenir.
- Route table (kurallar dizisi) and Router (kurallarin icrasi) : Passport
- Security Group and Network Access List (NACL) : Security komponentleri
- Bir VPC tek bir Region de o region icindeki farkli AZ lerde olusturuluyor.
- Evin kapisi Security Group, sitenin disindaki duvarlar da NACL dir.
- CIDR: Classless Inter-Domain Routing. Kesmeden sonraki rakam büyüdükce host IP sayisi azaliyor!
- CIDR 10.0.0.0/16 demek IP adresi 10.0.0.0 Subnetmask 255.255.0.0 demek yani Subnetmaskta 16 tane 1 var. Bu durumda 65536 tane host IP vardir.
- CIDR 10.0.1.0/24 demek IP adresi 10.0.1.0 Subnetmask 255.255.255.0 demek yani Subnetmaskta 24 tane 1 var. Bu durumda 256 tane host IP vardir.
- CIDR 10.0.1.0/32 demek IP adresi 10.0.1.0 Subnetmask 255.255.255.255 demek yani Subnetmaskta 32 tane 1 var. Bu durumda 1 tane host IP vardir.
- Her durumda 5 tane Allocated IP var. 10.0.0.0/24 Address Indicator, 10.0.0.1/24 VPC Router, 10.0.0.2/24 DNS, 10.0.0.3/24 Reserved, 10.0.0.4/24 Broadcast
- Security Group EC2 Instance in bodyguard i olarak calisir (instance-based). NACL ise biraz daha uzaktan AZ yi korur (subnet-based). Subnet teki bir Instance hem Security Group hem NACL rules dan etkilenir. (Eyalet sistemi devlet yapisi gibi). NACL daha ayrintilidir. 
- Security Group da sadece ALLOW Rules var, NACL da ALLOW and DENY Rules var.
- Security Group da default olarak inbound Rules DENIED, outbound Rules ALLOW gelir, NACL da tüm Rules default olarak ALLOW gelir. Yeni NACL olusturuyorsak tüm Rules default olarak DENIED gelir.
- Instance a ulasmak icin once NACL Inbound Rules gecilir sonra Security Group Inbound Rules gecilir. Instance dan cikarken Security Group Outbound Rules Security Group inbound Rules ile haberlestigi icin cikmasina izin verir, ancak NACL Inbound Rules NACL Outbound Rules ile haberlesmez, ayrica NACL Outbound Rules da belirtmek lazim.
- Security Group Stateful : inbound a verilen Rule outbound icin de gecerlidir.  Aralarinda haberlesiyorlar. Girerken kimlik gosteriyorsun, cikarken kimlik gostermene gerek yok. Girerken kullandigin portu cikarken de kullaniyorsun.
- NACL Stateless : inbound a verilen Rule outbound icin de gecerli degildir. Aralarinda haberlesmiyorlar. Girerken kimlik gosteriyorsun, cikarken de kimlik gostermelisin. Girerken kullandigin porttan cikarken cikamiyorsun. Outbound icin TCP protokolunde 32768-65535 arasindan gecici port (FMNR Port) ayarlaniyor.
- Bir VPC olusturulurken izlenmesi gerek yol:
1) VPC olustur
2) Internet Gateway (IGW) olustur. (Dis hatlar terminali olustur)
3) IGW action mneu : Attach IGW to VPC
4) VPC action menu : Edit DNS Hostname - Enable: Resource lara bu DNS verilmesi icin
5) Set the VPC Route Table : Edit Routes->Add route->Destination: 0.0.0.0/0, Target: Internet Gatteway
6) Name Default Route Table : default-labvpc

- Transport (ulasim) kismini Internet Gateway ve Route Table düzenliyor, Security kismini ise Security #group ve NACL düzenliyor.
- Handson kapsaminda bir VPC nin 3 farkli AZ sinde CIDR bloklari farkli olacak sekilde birer tane Public Subnet birer tane Private Subnet olusturuyoruz. 
- Public ve Private Subnet lere birer tane Route table olustururuz ki Private subnet lere internet gateway uzerinden giris olmasin! Cunku Private subnet lerde harici hat yoktu. Olusturulan route table lara subnet ler associate edilir. Public icin yeni olusturulan route table da Edit Routes->Add route->Destination: 0.0.0.0/0, Target: Internet Gatteway eklenir. Public subnet lere gidip her public subnet in actions sekmesinden Auto assign IP settings e tikla ve IPv4 sec.
- Tüm ayarlardan sonra;
1) public subnet te bir EC2 Instance olusturunca bu EC2 Instance a hem VPC CIDR pool dan bir private IP ve hem de AWS IP Pool dan bir public IP verilir. 
2) private subnet te bir EC2 Instance olusturunca bu EC2 Instance a sadece VPC CIDR pool dan bir private IP verilir. 

- Private subnet teki private IP li  EC2 Instance a lokal terminalden ssh ile baglanamayiz, cunku elimizde sadece private IP yani dahili telefon no var. Private IP li EC2 Instance a disaridan baglanmanin yolu Bastion Host. Yani once public subnet teki bir EC2 Instance a baglaniriz ve onun üstünde ssh ile Private subnet teki private IP li  EC2 Instance a ziplariz (jump box). 
- Private subnet teki private IP li EC2 Instance a User Data koysaydik User Datadaki islemler gerceklesmezdi. Cunku internete cikamayacagi icin paketleri indiremezdi.

# Hands-on VPC-01 : Configuring of VPC

Purpose of the this hands-on training is to create VPC and configure VPC with components.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- learn how to create VPC,

- learn how to create subnet,

- learn how to set route tables as public and private,

- learn how to create Bastion host and connect to private subnet from internet

- learn how to create NAT Gateway and NAT Instance

- learn how to create VPC peering between two VPCs

- learn how to create VPC endpoint 

- learn how to use NACL (Network Access List)

## Outline

- Part 1 - Creating VPC, Subnet and Subnet associations

- Part 2 - Creating Bashion Host and connect to the private subnet from internet

- Part 3 - Creating NAT Gateway

- Part 4 - Creating NAT Instance

- Part 5 - Creating VPC peering between two VPCs

- Part 6 - Creating VPC Endpoint

- Part 7 - Configuring NACL 

## Part 1 - Creating VPC, Subnet and Subnet associations

STEP 1: Create VPC

- First, go to the VPC and select Your VPC section from the left-hand menu, click create VPC.

- create a vpc named 'clarus-vpc-a' with 10.7.0.0/16 CIDR
    - no ipv6 CIDR block
    - tenancy: default

- click create

- explain the vpc descriptions

- enable DNS hostnames for the vpc 'clarus-vpc-a'

  - select 'clarus-vpc-a' on VPC console ----> Actions ----> Edit DNS hostnames
  - Click enable flag
  - Click save 

STEP 2: Create an internet gateway named 'clarus-igw'

- Go to the Internet Gateways from left hand menu

- Create Internet Gateway
   - Name Tag "clarus-igw" 
   - Click create button

-  attach the internet gateway 'clarus-igw' to the vpc 'clarus-vpc-a'
  - Actions ---> attach to VPC
  - Select VPC named "clarus-vpc-a"
  - Push "Attach Internet gateway"

STEP 3 : Configuring Route Table

- Go to the Route Tables from left hand menu

- rename the route table of the vpc 'clarus-vpc-a' as 'clarus-default-rt'

- select Routes on the sub-section

- click edit routes

- click add route

- add a route
    - destination ------> 0.0.0.0/0 (any network, any host)
    - As target;
      - Select Internet Gateway
      - Select 'clarus-igw'
      - save routes

- explain routes in the clarus-default-rt

STEP 4: Create Subnets
- Go to the Subnets from left hand menu
- Push create subnet button

1. 
Name tag          :clarus-az1a-public-subnet
VPC               :clarus-vpc-a
Availability Zone :us-east-1a
IPv4 CIDR block   :10.7.1.0/24

2. 
Name tag          :clarus-az1a-private-subnet
VPC               :clarus-vpc-a
Availability Zone :us-east-1a
IPv4 CIDR block   :10.7.2.0/24

3. 
Name tag          :clarus-az1b-public-subnet
VPC               :clarus-vpc-a
Availability Zone :us-east-1b
IPv4 CIDR block   :10.7.4.0/24

4. 
Name tag          :clarus-az1b-private-subnet
VPC               :clarus-vpc-a
Availability Zone :us-east-1b
IPv4 CIDR block   :10.7.5.0/24

5. 
Name tag          :clarus-az1c-public-subnet
VPC               :clarus-vpc-a
Availability Zone :us-east-1c
IPv4 CIDR block   :10.7.7.0/24

6. 
Name tag          :clarus-az1c-private-subnet
VPC               :clarus-vpc-a
Availability Zone :us-east-1c
IPv4 CIDR block   :10.7.8.0/24

- explain the subnet descriptions and reserved ips (why 251 instead of 256)

STEP 5: Route Tables

- Go to the Route Tables from left hand menu

- Select 'clarus-default-rt' and click the Subnet Association from sub-section

- show the default subnet associations on the route table 
clarus-default-rt (internet access is available even on private subnets)
- push the create route table button

- create a private route table (not allowing access to the internet) 
  - name: 'clarus-private-rt'
  - VPC : 'clarus-vpc-a'
  - click create button

- show the routes in the route table clarus-private-rt,

- click Subnet association button and show the route table clarus-private-rt with private subnets

- Click Edit subnet association
- select private subnets;
  - clarus-az1a-private-subnet
  - clarus-az1b-private-subnet
  - clarus-az1c-private-subnet
  - and click save

- create a public route table (allowing access to the internet) 

- push the create route table button
  - name: 'clarus-public-rt'
  - VPC : 'clarus-vpc-a'
  - click create button

- show the routes in the route table clarus-public-rt,

- click Subnet association button and show the route table 

-Show the default route table subnet association . There are only 3 subnet implicitly.

- clarus-public-rt with public subnets

- Click Edit subnet association

- select public subnets;
  - clarus-az1a-public-subnet
  - clarus-az1b-public-subnet
  - clarus-az1c-public-subnet
  - and click save

- select Routes on the sub-section of clarus-public-rt

- click edit routes

- click add route

- add a route
    - destination ------> 0.0.0.0/0 (any network, any host)
    - As target;
      - Select Internet Gateway
      - Select 'clarus-igw'
      - save routes    
      
STEP 6: enable Auto-Assign Public IPv4 Address for public subnets

- Go to the Subnets from left hand menu

  - Select 'clarus-az1a-public-subnet' subnet ---> Action ---> Edit Subnet Settings ---> select 'Enable auto-assign public IPv4 address' ---> Save

  - Select 'clarus-az1b-public-subnet' subnet ---> Action ---> Edit Subnet Settings ---> select 'Enable auto-assign public IPv4 address' ---> Save

  - Select 'clarus-az1c-public-subnet' subnet ---> Action ---> Edit Subnet Settings ---> select 'Enable auto-assign public IPv4 address' ---> Save

- Create two instances . One is in the Private and the other one is in Public subnet. Show the public and private IPs of instances.


