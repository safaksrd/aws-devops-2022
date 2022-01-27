Ozet: 06.10.2020

- Klasik senaryoda statik web sayfamizi S3 bucket uzerinden yayinliyorduk. Her requestte webpage in lokal olarak bulundugu S3 Bucketa kadar gidip dönüyoruz. 
- Cloud Front mimarisinde her seferinde S3 Bucketa kadar gitmeye gerek yok. Cloud Front bir CDN (Content Delivery Network) dir. Edge Locations ve Edge Caches lardan olusan Points of Presence (PoP) larda bizim web sayfamizin cache verisini tutuyor, request oldugunda bu cache den web sayfamizi gosteriyor. Böylece Latency azaliyor. Web sayfasinin icerigini edge location lardan daha hizli dagitmis (distribution) olacagiz. 
- AWS Certicate Manager araciligi ile bir SSL sertifika aliyoruz. Cloud Front ayarlarinda bu sertifika kullanilacak.
- Ozetle;
    1. Lokalden gordugumuz web sayfasini
    2. Once S3 bucket adresinden, 
    3. Sonra SSL sertifika baglanmis sekilde Cloud Front adresinden,
    4. Son olarak kendi dns name imizden goruyoruz.
- Invalidation islemi: S3 Bucket ta icerik guncellesek bile web sayfamiza request olduugnda TTL süresü boyunca Edge locations cache deki icerik gelir. Bunu engellemek icin Cloud Front menusunde invalidation sekmesinden soruna aninda mudahale edip tüm cache bilgilerini degistirebiliriz.
- Geo-Restrictions islemi: Istedigimiz ülkeleri kara veya beyaz listeye ekleriz.



## Part 1 - Creating a Certificate 

- Go to Certificate Manager service and select "Provision Certificates" ----> "Get Started"

- Click on "Request a public certificate" and hit the "Request Certificate"

```

      -  Add domain names          : "[your donamin name].net" (naked domain name) and click next

      -  Select validation method  : "DNS validation"
  
      -  Add tags                  : Skip this part
  
      -  Review and click "Comfirm and Request"
```

-  To complete the  process click "Continue" button

-  On Certificates page Click on your newly created certificate.

-  Status >>> Domain >>> [your donamin name] 

-  Then at the bottom of the page click "Create record in Route 53" button.

-  Click "create" on the pop-up menu.

-  It takes a while to be ready.  

## Part 2 - Creating a Static WebSite Hosting 

1. Go to S3 service and create a bucket with domain name: "[your donamin name].net"
  - Public Access Enabled
  - Upload Files named "index.html" and "ryu.jpg" in "v1" folder
  - Permissions>>> Bucket Policy >>> Paste bucket Policy
```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::please paste your ARN name/*"
        }
    ]
}
```
  - Preporties>>> Set Static Web Site >>> Enable >>> Index document : index.html 
 
 ## Part 3 - Create CloudFront Distribution 

- First of all we need to copy endpoint of S3 static website bucket.

- Go to the S3 service click on S3 static website bucket >>> Properties >>> Static Web Hosting >>> Copy the endpoint (without https://).

- Go to CloudFront service and select "Create distribution"

- Select a delivery method for your content: Choose "Web" option and click on "Get Started"
- Create Distribution : 
  
  - Origin Settings: Cloud Front ile S3 ü burada bulusturuyoruz.
      - Origin Domain Name: Paste the "endpoint" (without https://) of the S3 bucket
  
  - Default Cache Behavior Settings
      - Viewer Protocol Policy: Select "Redirect HTTP to HTTPS"
 
  - Distribution Settings: Cloud Front ile Domain Name i burada bulusturuyoruz ve SSL i tanimliyoruz.
      - Alternate Domain Names (CNAMEs): [your donamin name]
      - SSL Certificate: Select "Custom SSL Certificate (example.com)" >>> select your newly created certificate
     
- Leave the other settings as default.

- Click "Create Distribution".

- It may take some time distribution to be deployed. (Check status of distribution to be "Deployed")

- When it is deployed, copy the "Domain name" of the distribution. 
- Bu islemin sonunda S3 un verdigi xx.s3-xxx.amazonaws.com dns name yerine cloud Front un edge locationlara koyacagi distribution icin olusturdugu d ile baslayan cloudfront.net ile biten bir adres elde ediyoruz. Yani artik S3 bucket imizi Cloud Front dagitiyor. Ama halen bu adres bizim web sayfamizin adi degil. Sirada web sayfamizin adini Route 53 uzerinden Cloud Front a tanitmaya geldi.

## Part 4 - Creating Route 53 record sets (Alias)
- Cloud Front ile Route 53 i burada bulusturuyoruz. Cloud Front web sayfa

- click your Domain name's public hosted zone

- click "create record"

- select "simple routing" ---> Next

- click "Define simple record"

```bash
Record Name: None
Value/Route traffic to: 
    - Alias to CloudFront distribution endpoint
    - US East (N.Virginia) [us-east-1]
    - choose your CloudFront distribution endpoint
Record Type : A
```
- hit the define simple record

- Select newly created record's flag and hit the "create record" 
tab seen bottom

- go to the target domain name "[your DNS name].net" on browser

- check it is working with "https protocol"

- show the content of web page.
- Bu islemin sonunda cloud Front un olusturdugu d ile baslayan cloudfront.net yerine kendi dns name imiz ile web sayfamiza baglaniyoruz.


## Part 5 - Configuring CloudFront Distribution

Step-1 - Invalidation

 - Go to your S3 bucket hosting the website and put the "ryu.jpg" file in the "v2" folder (not in v1) to your bucket. 

 - Go to the target domain name "[your DNS name].net" on browser and notice the image has't been changed.
 
 - Go to the CloudFront Menu and select the newly created distribution.
 
 - Select the subsection of "Invalidation" tab and click "Create Invalidation"
 
 - On the opening page enter "/ryu.jpg" and click "Invalidate". 
 
 - After the invalidation process is completed, check the website and notice the image is updates now.
 
Step-2 - Geo Restriction

 - Go to the CloudFront Menu and select the newly created distribution.
  
 - Select the subsection of "Restriction" tab >>> Geo Restriction >>> Edit
 
 - Enable Geo-Restriction : Yes
 
 - Restriction Type : Black List
 
 - Countries : US-United States >>> Add
 
 - Click "Yes Edit"

 - After the restriction process is completed, check the website and notice the webpage is blocked.
