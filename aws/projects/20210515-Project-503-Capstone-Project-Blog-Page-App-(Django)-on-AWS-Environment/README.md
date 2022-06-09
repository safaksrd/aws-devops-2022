Ozet: 15.05.2021

- RDS olustururken bugune dek Subnet olusturmamistik. Ama projede RDS i Private Subnet icine koyacagimiz icin Subnet olusturmamiz gerekiyor.
- NAT Instance ilk kuruldugunda yapilmasi gerekenler: Actions Menu -> Networking -> Enable Source/Destination Check -> Stop, Save et: NAT Instance a diyoruz ki Source check yapma, sana ne geliyorsa trafigi yonlendir anlamina geliyor.

# Project-503 : Blog Page Application (Django) deployed on AWS Application Load Balancer with Auto Scaling, S3, Relational Database Service(RDS), VPC's Components, Lambda, DynamoDB and Cloudfront with Route 53

## Description

The Clarusway Blog Page Application aims to deploy blog application as a web application written Django Framework on AWS Cloud Infrastructure. This infrastructure has Application Load Balancer with Auto Scaling Group of Elastic Compute Cloud (EC2) Instances and Relational Database Service (RDS) on defined VPC. Also, The Cloudfront and Route 53 services are located in front of the architecture and manage the traffic in secure. User is able to upload pictures and videos on own blog page and these are kept on S3 Bucket. This architecture will be created by Firms DevOps Guy.

## Problem Statement

![Project_004](capstone.jpg)

- Your company has recently ended up a project that aims to serve as Blog web application on isolated VPC environment. You and your colleagues have started to work on the project. Your Developer team has developed the application and you are going to deploy the app in production environment.

- Application is coded by Clarusway Fullstack development team and given you as DevOps team. App allows users to write their own blog page to whom user registration data should be kept in separate MySQL database in AWS RDS service and pictures or videos should be kept in S3 bucket. The object list of S3 Bucket containing movies and videos is recorded on DynamoDB table. 

- The web application will be deployed using Django framework.

- The Web Application should be accessible via web browser from anywhere in secure.

- You are requested to push your program to the project repository on the Github. You are going to pull it into the webservers in the production environment on AWS Cloud. 

In the architecture, you can configure your infrastructure using the followings,

  - The application stack should be created with new AWS resources.

  - Specifications of VPC:

    - VPC has two AZs and every AZ has 1 public and 1 private subnets.

    - VPC has Internet Gateway

    - One of public subnets has NAT Instance.

    - You might create new instance as Bastion host on Public subnet or you can use NAT instance as Bastion host.

    - There should be managed private and public route tables.

    - Route tables should be arranged regarding of routing policies and subnet associations based on public and private subnets.

  - You should create Application Load Balancer with Auto Scaling Group of Ubuntu 18.04 EC2 Instances within created VPC.

  - You should create RDS instance within one of private subnets on created VPC and configure it on application.

  - The Auto Scaling Group should use a Launch Template in order to launch instances needed and should be configured to;

    - use all Availability Zones on created VPC.

    - set desired capacity of instances to  ` 2`

    - set minimum size of instances to  ` 2`

    - set maximum size of instances to  ` 4`

    - set health check grace period to  ` 90 seconds`

    - set health check type to  ` ELB`

    - Scaling Policy --> Target Tracking Policy

      - Average CPU utilization (set Target Value ` %70`)

      - seconds warm up before including in metric ---> `200`

      - Set notification to your email address for launch, terminate, fail to launch, fail to terminate instance situations

  - ALB configuration;
    
    - Application Load Balancer should be placed within a security group which allows HTTP (80) and HTTPS (443) connections from anywhere. 
    
    - Certification should be created for secure connection (HTTPS) 
      - To create certificate, AWS Certificate Manager can be utilized.

    - ALB redirects to traffic from HTTP to HTTPS

    - Target Group
      - Health Check Protocol is going to be HTTP

  - The Launch Template should be configured to;

    - Prepare Django environment on EC2 instance based on Developer Notes,

    - Download the "clarusway_aws_capstone" folder from Github repository,

    - Install the requirements using requirements.txt in 'clarusway_aws_capstone' folder

    - Deploy the Django application on port 80.

    - Launch Template only allows HTTP (80) and HTTPS (443) ports coming from ALB Security Group and SSH (22) connections from anywhere.

    - EC2 Instances type can be configured as `t2.micro`.

    - Instance launched should be tagged `Clarusway AWS Capstone Project`

    - Since Django App needs to talk with S3, S3 full access role must be attached EC2s. 

  - For RDS Database Instance;
  
    - Instance type can be configured as `db.t2.micro`

    - Database engine can be `MySQL` with version of `8.0.20`.

    - RDS endpoint should be addressed within settings file of blog application that is explained developer notes.

    - Please read carefully "Developer notes" to manage RDS sub settings.

  - Cloudfront should be set as a cache server which points to Application Load Balance with following configurations;

    - The cloudfront distribution should communicate with ALB securely.

    - Origin Protocol policy can be selected as `HTTPS only`.

    - Viewer Protocol Policy can be selected as `Redirect HTTP to HTTPS`

  - As cache behavior;

    - GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE methods should be allowed.

    - Forward Cookies must be selected All.

    - Newly created ACM Certificate should be used for securing connections. (You can use same certificate with ALB)

  - Route 53 

    - Connection must be secure (HTTPS). 

    - Your hostname can be used to publish website.

    - Failover routing policy should be set while publishing application
      
      - Primary connection is going to be Cloudformation

      - Secondary connection is going to be a static website placed another S3 bucket. This S3 bucket has just basic static website that has a picture said "the page is under construction" given files within S3_static_Website folder

      - Healthcheck should check If Cloudfront is healthy or not. 

  - As S3 Bucket

    - First S3 Bucket

      - It should be created within the Region that you created VPC

      - Since development team doesn't prefer to expose traffic between S3 and EC2s on internet, Endpoint should be set on created VPC. 

      - S3 Bucket name should be addressed within configuration file of blog application that is explained developer notes.
    
    - Second S3 Bucket 
      
      - This Bucket is going to be used for failover scenario. It has just a basic static website that has a picture said "the page is under construction"

  - To write the objects of S3 on DynamoDB table
    
    - Lambda Function 

      - Lambda function is going to be Python 3.8

      - Python Function can be found in github repo

      - S3 event is set as trigger

      - Since Lambda needs to talk S3 and DynamoDB and to run on created VPC, S3, DynamoDB full access policies and NetworkAdministrator policy must be attached it

      - `S3 Event` must be created first S3 Bucket to trigger Lambda function 

    - DynamoDB Table

      - Create a DynamoDB table which has primary key that is `id`

      - Created DynamoDB table's name should be placed on Lambda function.


## Project Skeleton 

```text
clarusway_blog_proj (folder)
|
|----Readme.md               # Given to the students (Definition of the project)
|----src (folder)            # Given to the students (Django Application's )
|----requirements.txt        # Given to the students (txt file)
|----lambda_function.py      # Given to the students (python file)
|----developer_notes.txt     # Given to the students (txt file)
```

## Expected Outcome

![Phonebook App Search Page](./outcome.png)

### At the end of the project, following topics are to be covered;

- Bash scripting

- AWS EC2 Launch Template Configuration

- AWS VPC Configuration
  - VPC
  - Private and Public Subnets
  - Private and Public Route Tables
  - Managing routes
  - Subnet Associations
  - Internet Gateway
  - NAT Gateway
  - Bastion Host
  - Endpoint

- AWS EC2 Application Load Balancer Configuration

- AWS EC2 ALB Target Group Configuration

- AWS EC2 ALB Listener Configuration

- AWS EC2 Auto Scaling Group Configuration

- AWS Relational Database Service Configuration

- AWS EC2, RDS, ALB Security Groups Configuration

- IAM Roles configuration

- S3 configuration

- Static website configuration on S3

- DynamoDB Table configuration

- Lambda Function configuration

- Get Certificate with AWS Certification Manager Configuration

- AWS Cloudfront Configuration

- Route 53 Configuration

- Git & Github for Version Control System

### At the end of the project, students will be able to;

- Construct VPC environment with whole components like public and private subnets, route tables and managing their routes, internet Gateway, NAT Instance. 

- Apply web programming skills, importing packages within Python Django Framework

- Configure connection to the `MySQL` database.

- Demonstrate bash scripting skills using `user data` section within launch template to install and setup Blog web application on EC2 Instance.

- Create a Lambda function using S3, Lambda and DynamoDB table.

- Demonstrate their configuration skills of AWS VPC, EC2 Launch Templates, Application Load Balancer, ALB Target Group, ALB Listener, Auto Scaling Group, S3, RDS, Cloudfront, Route 53.

- Apply git commands (push, pull, commit, add etc.) and Github as Version Control System.

## Steps to Solution
  
### Step 1: Create dedicated VPC and whole components
        
    ### VPC
    - Create VPC. 
        create a vpc named `aws_capstone-VPC` CIDR blok is `90.90.0.0/16` 
        no ipv6 CIDR block
        tenancy: default
    - select `aws_capstone-VPC` VPC, click `Actions` and `enable DNS hostnames` for the `aws_capstone-VPC`. 

    ## Subnets
    - Create Subnets
        - Create a public subnet named `aws_capstone-public-subnet-1A` under the vpc aws_capstone-VPC in AZ us-east-1a with 90.90.10.0/24
        - Create a private subnet named `aws_capstone-private-subnet-1A` under the vpc aws_capstone-VPC in AZ us-east-1a with 90.90.11.0/24
        - Create a public subnet named `aws_capstone-public-subnet-1B` under the vpc aws_capstone-VPC in AZ us-east-1b with 90.90.20.0/24
        - Create a private subnet named `aws_capstone-private-subnet-1B` under the vpc aws_capstone-VPC in AZ us-east-1b with 90.90.21.0/24

    - Set `auto-assign IP` up for public subnets. Select each public subnets and click Modify "auto-assign IP settings" and select "Enable auto-assign public IPv4 address" 

    ## Internet Gateway

    - Click Internet gateway section on left hand side. Create an internet gateway named `aws_capstone-IGW` and create.

    - ATTACH the internet gateway `aws_capstone-IGW` to the newly created VPC `aws_capstone-VPC`. Go to VPC and select newly created VPC and click action ---> Attach to VPC ---> Select `aws_capstone-VPC` VPC 

    ## Route Table
    - Go to route tables on left hand side. We have already one route table as main route table. Change it's name as `aws_capstone-public-RT` 
    - Create a route table and give a name as `aws_capstone-private-RT`.
    - Add a rule to `aws_capstone-public-RT` in which destination 0.0.0.0/0 (any network, any host) to target the internet gateway `aws_capstone-IGW` in order to allow access to the internet.
    - Select the private route table, come to the subnet association subsection and add private subnets to this route table. Similarly, we will do it for public route table and public subnets. 
        
    ## Endpoint
    - Go to the endpoint section on the left hand menu
    - select endpoint
    - click create endpoint
    - service name  : `com.amazonaws.us-east-1.s3`
    - VPC           : `aws_capstone-VPC`
    - Route Table   : private route tables
    - Policy        : `Full Access`
    - Create

### Step 2: Create Security Groups (ALB ---> EC2 ---> RDS)

1. ALB Security Group
Name            : aws_capstone_ALB_Sec_Group
Description     : ALB Security Group allows traffic HTTP and HTTPS ports from anywhere 
Inbound Rules
VPC             : AWS_Capstone_VPC
HTTP(80)    ----> anywhere
HTTPS (443) ----> anywhere

2. EC2 Security Groups
Name            : aws_capstone_EC2_Sec_Group
Description     : EC2 Security Groups only allows traffic coming from aws_capstone_ALB_Sec_Group Security Groups for HTTP and HTTPS ports. In addition, ssh port is allowed from anywhere
VPC             : AWS_Capstone_VPC
Inbound Rules
HTTP(80)    ----> aws_capstone_ALB_Sec_Group
HTTPS (443) ----> aws_capstone_ALB_Sec_Group
ssh         ----> anywhere

3. RDS Security Groups
Name            : aws_capstone_RDS_Sec_Group
Description     : RDS Security Groups only allows traffic coming from aws_capstone_EC2_Sec_Group Security Groups for MYSQL/Aurora port. 

VPC             : AWS_Capstone_VPC
Inbound Rules
MYSQL/Aurora(3306)  ----> aws_capstone_EC2_Sec_Group

4. NAT Instance Security Group
Name            : aws_capstone_NAT_Sec_Group
Description     : NAT Instance Security Group allows traffic HTTP and HTTPS and SSH ports from anywhere 
Inbound Rules
VPC             : AWS_Capstone_VPC
HTTP(80)    ----> anywhere
HTTPS (443) ----> anywhere
SSH (22)    ----> anywhere

### Step 3: Create RDS
First we create a subnet group for our custom VPC. Click `subnet Groups` on the left hand menu and click `create DB Subnet Group` 
```text
Name               : aws_capstone_RDS_Subnet_Group
Description        : aws capstone RDS Subnet Group
VPC                : aws_capstone_VPC
Add Subnets
Availability Zones : Select 2 AZ in aws_capstone_VPC
Subnets            : Select 2 Private Subnets in these subnets

```
- Go to the RDS console and click `create database` button
```text
Choose a database creation method : Standart Create
Engine Options  : Mysql
Version         : 8.0.20
Templates       : Free Tier
Settings        : 
    - DB instance identifier : aws-capstone-RDS
    - Master username        : admin
    - Password               : Clarusway1234 
DB Instance Class            : Burstable classes (includes t classes) ---> db.t2.micro
Storage                      : 20 GB and enable autoscaling(up to 40GB)
Connectivity:
    VPC                      : aws_capstone_VPC
    Subnet Group             : aws_capstone_RDS_Subnet_Group
    Public Access            : No 
    VPC Security Groups      : Choose existing ---> aws_capstone_RDS_Sec_Group
    Availability Zone        : No preference
    Additional Configuration : Database port ---> 3306
Database authentication ---> Password authentication
Additional Configuration:
    - Initial Database Name  : database1
    - Backup ---> Enable automatic backups
    - Backup retention period ---> 7 days
    - Select Backup Window ---> Select 03:00 (am) Duration 1 hour
    - Maintance window : Select window    ---> 04:00(am) Duration:1 hour
create instance
```

### Step 4: Create two S3 Buckets and set one of these as static website.
Go to the S3 Consol and lets create two buckets. 

1. Blog Website's S3 Bucket

- Click Create Bucket
```text
Bucket Name : awscapstones3<YOUR NAME>blog
Region      : N.Virginia
Block all public access : Unchecked
Other Settings are keep them as are
create bucket

NOT!!: ACLs enabled yapmayi unutma. Serdar hocanin anlattigi menu farkliydi. S3 bucketa disaridan birinin birsey koyabilmesi icin bu ayar yapiliyor.
```

2. S3 Bucket for failover scenario

- Click Create Bucket
```text
Bucket Name : www.<YOUR DNS NAME>
Region      : N.Virginia
Block all public access : Unchecked
Please keep other settings as are
```
- create bucket

- Selects created `www.<YOUR DNS NAME>` bucket ---> Properties ---> Static website hosting
```text
Static website hosting : Enable
Hosting Type : Host a static website
Index document : index.html
save changes
```
- Select `www.<YOUR DNS NAME>` bucket ---> select Upload and upload `index.html` and `sorry.jpg` files from given folder---> Permissions ---> Grant public-read access ---> Checked warning massage

NOT!!: Permissions -> Bucket policy: derslerde kullanilan policy i eklemeyi unutma. Serdar hocanin anlattigi menu farkliydi.

## Step 5: Copy files downloaded or cloned from `Clarusway_project` repo on Github 

## Step 6: Prepair your Github repository
- Create private project repository on your Github and clone it on your local. Copy all files and folders which are downloaded from clarusway repo under this folder. Commit and push them on your private Git hup Repo.

## Step 7: Prepare a userdata to be utilized in Launch Template
Please 
```bash
#!/bin/bash
apt-get update -y
apt-get install git -y
apt-get install python3 -y
cd /home/ubuntu/
#TOKEN="xxxxxxx"
#git clone https://$TOKEN@<YOUR PRIVATE REPO URL>
git clone https://<YOUR PRIVATE REPO URL>
cd /home/ubuntu/<YOUR PRIVATE REPO NAME>
apt install python3-pip -y
apt-get install python3.7-dev default-libmysqlclient-dev -y
pip3 install -r requirements.txt
cd /home/ubuntu/<YOUR PRIVATE REPO NAME>/src
python3 manage.py collectstatic --noinput
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:80
```

## Step 8: Write RDS database endpoint and S3 Bucket name in settings file given by Clarusway Fullstack Developer team and push your application into your own public repo on Github
Please follow and apply the instructions in the developer_notes.txt.
```text
- Movie and picture files are kept on S3 bucket named aws_capstone_S3_<name>_Blog as object. You should create an S3 bucket and write name of it on "/src/cblog/settings.py" file as AWS_STORAGE_BUCKET_NAME variable. In addition, you must assign region of S3 as AWS_S3_REGION_NAME variable

- Users credentials and blog contents are going to be kept on RDS database. To connect EC2 to RDS, following variables must be assigned on "/src/cblog/settings.py" file after you create RDS;
    a. Database name - "NAME" variable 
    b. Database endpoint - "HOST" variables
    c. Port - "PORT"
    d. PASSWORD variable must be written on "/src/.env" file not to be exposed with settings file
```
- Please check if this userdata is working or not. to do this create new instance in public subnet and show to students that it is working

## Step 9: Create NAT Instance in Public Subnet
To launch NAT instance, go to the EC2 console and click the create button.

```text
write "NAT" into the filter box
select NAT Instance `amzn-ami-vpc-nat-hvm-2018.03.0.20181116-x86_64-ebs` 
Instance Type: t2.micro
Configure Instance Details  
    - Network : aws_capstone_VPC
    - Subnet  : aws_capstone-public-subnet-1A (Please select one of your Public Subnets)
    - Other features keep them as are
Storage ---> Keep it as is
Tags: Key: Name     Value: AWS Capstone NAT Instance
Configure Security Group
    - Select an existing security group: aws_capstone_NAT_Sec_Group
Review and select our own pem key
```

!!!IMPORTANT!!!
- select newly created NAT instance and enable stop source/destination check
- go to private route table and write a rule
```
Destination : 0.0.0.0/0
Target      : instance ---> Select NAT Instance
Save
```

## Step 10: Create Launch Template and IAM role for it
Go to the IAM role console click role on the right hand menu than create role
```text
trusted entity  : EC2 as  ---> click Next:Permission
Policy          : AmazonS3FullAccess policy
Tags            : No tags
Role Name       : aws_capstone_EC2_S3_Full_Access
Description     : For EC2, S3 Full Access Role
```

To create Launch Template, go to the EC2 console and select `Launch Template` on the left hand menu. Tab the Create Launch Template button.
```bash
Launch template name                : aws_capstone_launch_template
Template version description        : Blog Web Page version 1
Amazon machine image (AMI)          : Ubuntu 18.04
Instance Type                       : t2.micro
Key Pair                            : mykey.pem
Network Platform                    : VPC
Security Groups                     : aws_capstone_EC2_sec_group
Storage (Volumes)                   : keep it as is
Resource tags                       : Key: Name   Value: aws_capstone_web_server
Advance Details:
    - IAM instance profile          : aws_capstone_EC2_S3_Full_Access
    - Termination protection        : Enable
    - User Data
#!/bin/bash
apt-get update -y
apt-get install git -y
apt-get install python3 -y
cd /home/ubuntu/
TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
git clone https://$TOKEN@<YOUR PRIVATE REPO URL>
cd /home/ubuntu/<YOUR PRIVATE REPO NAME>
apt install python3-pip -y
apt-get install python3.7-dev default-libmysqlclient-dev -y
pip3 install -r requirements.txt
cd /home/ubuntu/<YOUR PRIVATE REPO NAME>/src
python3 manage.py collectstatic --noinput
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:80
```
- create launch template

## Step 11: Create certification for secure connection
Go to the certification manager console and click `request a certificate` button. Select `Request a public certificate`, then `request a certificate` ---> `*.<YOUR DNS NAME>` ---> DNS validation ---> No tag ---> Review ---> click confirm and request button. Then it takes a while to be activated. 

## Step 12: Create ALB and Target Group
Go to the Load Balancer section on the left hand side menu of EC2 console. Click `create Load Balancer` button and select Application Load Balancer
```text
Name                    : awscapstoneALB
Schema                  : internet-facing
Listeners               : HTTPS, HTTP
Availability Zones      : 
    - VPC               : aws_capstone_VPC
    - Availability zones: 
        1. aws_capstone-public-subnet-1A
        2. aws_capstone-public-subnet-1B
Step 2 - Configure Security Settings
Certificate type ---> Choose a certificate from ACM (recommended)
    - Certificate name    : "*.clarusway.us" certificate
    - Security policy     : keep it as is
Step 3 - Configure Security Groups : aws_capstone_ALB_Sec_group
Step 4 - Configure Routing
    - Target group        : New target group
    - Name                : awscapstoneTargetGroup
    - Target Type         : Instance
    - Protocol            : HTTP
    - Port                : 80
    - Protocol version    : HTTP1
    - Health Check        :
      - Protocol          : HTTP
      - Path              : /
      - Port              : traffic port
      - Healthy threshold : 5
      - Unhealthy threshold : 2
      - Timeout           : 5
      - Interval          : 20
      - Success Code      : 200
Step 5 - Register Targets
without register any target click Next: Review
```
- click create

To redirect traffic from HTTP to HTTPS, go to the ALB console and select Listeners sub-section.

```text
select HTTP: 80 rule ---> click edit
- Default action(s)
 - Remove existing rule and create new rule which is
    - Redirect to HTTPS 443
    - Original host, path, query
    - 301 - permanently moved
```
Lets go ahead and look at our ALB DNS --> it going to say "it is not safe", however, it will be fixed after settings of Route 53

## Step 13: Create Autoscaling Group with Launch Template 

Go to the Autoscaling Group on the left hand side menu. Click create Autoscaling group. 

- Choose launch template or configuration
```text 
Auto Scaling group name         : aws_capstone_ASG
Launch Template                 : aws_capstone_launch_template
```

- Configure settings

```text
Instance purchase options       : Adhere to launch template
Network                         :
    - VPC                       : aws-capstone-VPC
    - Subnets                   : Private 1A and Private 1B
```

- Configure advanced options

```text
- Load balancing                                : Attach to an existing load balancer
- Choose from your load balancer target groups  : awscapstoneTargetGroup
- Health Checks
    - Health Check Type             : ELB
    - Health check grace period     : 300
```

- Configure group size and scaling policies

```text
Group size
    - Desired capacity  : 2
    - Minimum capacity  : 2
    - Maximum capacity  : 4
Scaling policies
    - Target tracking scaling policy
        - Scaling policy name       : Target Tracking Policy
        - Metric Type               : Average CPU utilization
        - Target value              : 70
```

- Add notifications
```text
Create new Notification
    - Notification1
        - Send a notification to    : aws-capstone-SNS
        - with these recipients     : serdar@clarusway.com
        - event type                : select all 
```

<!-- WARNING!!! Sometimes your EC2 has a problem after you create autoscaling group, If you need to look inside one of your instance to make sure where the problem is, please follow these steps...

```bash
eval "$(ssh-agent)" (your local)
ssh-add <pem-key>   (your local )
ssh -A ec2-user@<Public IP or DNS name of NAT instance> (your local)
ssh ubuntu@<Public IP or DNS name of private instance>  (NAT instance)
You are in the private EC2 instance
``` -->

## Step 14: Create Cloudfront in front of ALB
Go to the cloudfront menu and click start
- Origin Settings
```text
Origin Domain Name          : aws-capstone-ALB-1947210493.us-east-2.elb.amazonaws.com
Origin Path                 : Leave empty (this means, define for root '/')
Protocol                    : Match Viewer
HTTP Port                   : 80
HTTPS                       : 443
Minimum Origin SSL Protocol : Keep it as is
Name                        : Keep it as is
Add custom header           : No header
Enable Origin Shield        : No
Additional settings         : Keep it as is
```
Default Cache Behavior Settings
```text
Path pattern                                : Default (*)
Compress objects automatically              : Yes
Viewer Protocol Policy                      : Redirect HTTP to HTTPS
Allowed HTTP Methods                        : GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
Cached HTTP Methods                         : Select OPTIONS
Cache key and origin requests
- Use legacy cache settings
  Headers     : Include the following headers
    Add Header
    - Accept
    - Accept-Charset
    - Accept-Datetime
    - Accept-Encoding
    - Accept-Language
    - Authorization
    - Cloudfront-Forwarded-Proto
    - Host
    - Origin
    - Referrer
Forward Cookies                         : All
Query String Forwarding and Caching     : All
Other stuff                             : Keep them as are 
```
- Distribution Settings
```text
Price Class                             : Use all edge locations (best performance)
Alternate Domain Names                  : www.clarusway.us
SSL Certificate                         : Custom SSL Certificate (example.com) ---> Select your certificate creared before
Other stuff                             : Keep them as are                  
```

## Step 15: Create Route 53 with Failover settings
Come to the Route53 console and select Health checks on the left hand menu. Click create health check
Configure health check

```text
Name                : aws capstone health check
What to monitor     : Endpoint
Specify endpoint by : Domain Name
Protocol            : HTTP
Domain Name         : Write cloudfront domain name
Port                : 80
Path                : leave it blank
Other stuff         : Keep them as are
```
- Click Hosted zones on the left hand menu

- click your Hosted zone        : <YOUR DNS NAME>

- Create Failover scenario

- Click Create Record

- Select Failover ---> Click Next
```text
Configure records
Record name             : www.<YOUR DNS NAME>
Record Type             : A - Routes traffic to an IPv4 address and some AWS resources
TTL                     : 300

---> First we'll create a primary record for cloudfront

Failover record to add to your DNS ---> Define failover record

Value/Route traffic to  : Alias to cloudfront distribution
                          - Select created cloudfront DNS
Failover record type    : Primary
Health check            : aws capstone health check
Record ID               : Cloudfront as Primary Record
----------------------------------------------------------------

---> Second we'll create secondary record for S3

Failover another record to add to your DNS ---> Define failover record

Value/Route traffic to  : Alias to S3 website endpoint
                          - Select Region
                          - Your created bucket name emerges ---> Select it
Failover record type    : Secondary
Health check            : No health check
Record ID               : S3 Bucket for Secondary record type
```

- click create records

## Step 16: Create DynamoDB Table
Go to the Dynamo Db table and click create table button

- Create DynamoDB table
```text
Name            : awscapstoneDynamo
Primary key     : id
Other Stuff     : Keep them as are
click create
```

## Step 17-18: Create Lambda function

Before we create our Lambda function, we should create IAM role that we'll use for Lambda function. Go to the IAM console and select role on the left hand menu, then create role button
```text
Select Lambda as trusted entity ---> click Next:Permission
Choose: - LambdaS3fullaccess, 
        - Network Administrator
        - DynamoDBFullAccess
No tags
Role Name           : aws_capstone_lambda_Role
Role description    : This role give a permission to lambda to reach S3 and DynamoDB on custom VPC
```

then, go to the Lambda Console and click create function

- Basic Information
```text

Function Name           : awscapsitonelambdafunction
Runtime                 : Python 3.8
Create IAM role         : S3 full access policy

Advance Setting:
Network                 : 
    - VPC               : aws-capstone-VPC
    - Subnets           : Select all subnets
    - Security Group    : Select default security Group
```

- Now we'll go to the S3 bucket belongs our website and create an event to trigger our Lambda function. 

## Step 17-18: Create S3 Event and set it as trigger for Lambda Function

Go to the S3 console and select the S3 bucket named `awscapstonec3<name>blog`.

- Go to the properties menu ---> Go to the Event notifications part

- Click create event notification for creating object
```text
Event Name              : aws capstone S3 event
Prefix                  : media/
Select                  :
    - All object create events
Destination             : Lambda Function
Specify Lambda function : Choose from your Lambda functions 
Lambda funstion         : awscapstonelambdafunction
click save
```text

```
- After create an event go to the `awscapstonelambdafunction` lambda Function and click add trigger on the top left hand side.

- For defining trigger for creating objects
```text
Trigger configuration   : S3
Bucket                  : awscapstonec3<name>blog
Event type              : All object create events
Check the warning message and click add ---> sometimes it says overlapping situation. When it occurs, try refresh page and create a new trigger or remove the s3 event and recreate again. then again create a trigger for lambda function
```

- For defining trigger for deleting objects
```bash

Trigger configuration   : S3
Bucket                  : awscapstonec3<name>blog
Event type              : All object delete events
Check the warning message and click add ---> sometimes it says overlapping situation. When it occurs, try refresh page and create a new trigger or remove the s3 event and recreate again. then again create a trigger for lambda function
```

- Go to the code part and select lambda_function.py ---> remove default code and paste a code on below. If you give DynamoDB a different name, please make sure to change it into the code. 

```python
import json
import boto3

def lambda_handler(event, context):
    s3 = boto3.client("s3")
    
    if event:
        print("Event: ", event)
        filename = str(event['Records'][0]['s3']['object']['key'])
        timestamp = str(event['Records'][0]['eventTime'])
        event_name = str(event['Records'][0]['eventName']).split(':')[0][6:]
        
        filename1 = filename.split('/')
        filename2 = filename1[-1]
        
        dynamo_db = boto3.resource('dynamodb')
        dynamoTable = dynamo_db.Table('awscapstoneDynamo')
        
        dynamoTable.put_item(Item = {
            'id': filename2,
            'timestamp': timestamp,
            'Event': event_name,
        })
        
    return "Lammda success"
```

- Click deploy and all set. go to the website and add a new post with photo, then control if their record is written on DynamoDB. 

- WE ALL SET

- Congratulations!! You have finished your AWS Capstone Project

## Notes

- RDS database should be located in private subnet. just EC2 machines that has ALB security group can talk with RDS.

- RDS is located on private groups and only EC2s can talk with it on port 3306

- ALB is located public subnet and it redirects traffic from http to https

- EC2's are located in private subnets and only ALB can talk with them


## Resources

- [Python Django Framework](https://www.djangoproject.com/)

- [Python Django Example](https://realpython.com/get-started-with-django-1/)

- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/index.html)
