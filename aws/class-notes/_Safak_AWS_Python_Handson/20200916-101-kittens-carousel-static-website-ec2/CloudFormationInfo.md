 cfn yazinca ana cati geliyor!!
 cfn-lite yazinca daha sade hali geliyor. Bu hali genelde bize yetiyor.
 
 https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html sitesinde ayrintili aciklamalar var.

# Template sections
Templates include several major sections. The Resources section is the only required section. Some sections in a template can be in any order. However, as you build your template, it can be helpful to use the logical order shown in the following list because values in one section might refer to values from a previous section.

# Format Version (optional)
The AWS CloudFormation template version that the template conforms to. The template format version isn't the same as the API or WSDL version. The template format version can change independently of the API and WSDL versions.

# Description (optional)
A text string that describes the template. This section must always follow the template format version section.

# Metadata (optional)
Objects that provide additional information about the template.

# Parameters (optional)
Kullanicidan belirlemesini istedigimiz parametreleri burada gireriz. Ornegin key name, EC2 türleri

Values to pass to your template at runtime (when you create or update a stack). You can refer to parameters from the Resources and Outputs sections of the template.

# Rules (optional)
Validates a parameter or a combination of parameters passed to a template during a stack creation or stack update.

# Mappings (optional)
Kullaniciyi bizim amacimiza gore yonlendirir. Ornegin bir Region dan baglanan bir kullanici icin AMI kisitlamasi yapilabilir.

Ornegin:

AWSTemplateFormatVersion: "2010-09-09"
Mappings: 
  RegionMap: 
    us-east-1:
      HVM64: ami-0ff8a91507f77f867
      HVMG2: ami-0a584ac55a7631c0c
    us-west-1:
      HVM64: ami-0bdb828fd58c52235
      HVMG2: ami-066ee5fd4a9ef77f1
    eu-west-1:
      HVM64: ami-047bb4163c506cd98
      HVMG2: ami-0a7c483d527806435
    ap-northeast-1:
      HVM64: ami-06cd52961ce9f0d85
      HVMG2: ami-053cdd503598e4a9d
    ap-southeast-1:
      HVM64: ami-08569b978cc4dfa10
      HVMG2: ami-0be9df32ae9f92309
Resources: 
  myEC2Instance: 
    Type: "AWS::EC2::Instance"
    Properties: 
      ImageId: !FindInMap [RegionMap, !Ref "AWS::Region", HVM64] 
# (NOT: Koseli parantez yerine altalta basina cizgi koyarak da yazilabilir.)
      ImageId: !FindInMap 
        - RegionMap
        - !Ref "AWS::Region"
        - HVM64
      InstanceType: m1.small

Resources kisminda bulunan ImageId soyle calisir. 
FindInMap ile Mappings bölümünde RegionMap i bulur, !Ref "AWS::Region" kismi icin us-east-1, us-west-1, eu-west-1, ap-northeast-1, ap-southeast-1 regionlarindan hangisinde o an calisiyorsak onu belirler. Yanina da HVM64 ya da HVMG2 den hangisi secilmis ise onun karsisindaki ami degerini alir, buoylelikle hangi ami nin kullanilacagi belirlenir.

A mapping of keys and associated values that you can use to specify conditional parameter values, similar to a lookup table. You can match a key to a corresponding value by using the Fn::FindInMap intrinsic function in the Resources and Outputs sections.

# Conditions (optional)
Conditions that control whether certain resources are created or whether certain resource properties are assigned a value during stack creation or update. 
For example, you could conditionally create a resource that depends on whether the stack is for a production or test environment.
Production ortamindan biri EC2 yu olusturuyorsa Volume mount edelim, test ortamindan biri EC2 yu olusturuyorsa Volume mount etmeyelim.

# Transform (optional)
For serverless applications (also referred to as Lambda-based applications), specifies the version of the AWS Serverless Application Model (AWS SAM) to use. When you specify a transform, you can use AWS SAM syntax to declare resources in your template. The model defines the syntax that you can use and how it's processed.

You can also use AWS::Include transforms to work with template snippets that are stored separately from the main AWS CloudFormation template. You can store your snippet files in an Amazon S3 bucket and then reuse the functions across multiple templates.

# Resources (required)
Specifies the stack resources and their properties, such as an Amazon Elastic Compute Cloud instance or an Amazon Simple Storage Service bucket. You can refer to resources in the Resources and Outputs sections of the template.

Mappings deki ayarlari cagirmak icin !FindInMap kullanilir.

# Outputs (optional)
Describes the values that are returned whenever you view your stack's properties. For example, you can declare an output for an S3 bucket name and then call the aws cloudformation describe-stacks AWS CLI command to view the name.

