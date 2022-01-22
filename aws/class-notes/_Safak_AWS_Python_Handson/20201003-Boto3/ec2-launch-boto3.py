import boto3
ec2 = boto3.resource('ec2')

# create a new EC2 instance
instances = ec2.create_instances(
     ImageId='ami-08e4e35cccc6189f4',
     MinCount=1,
     MaxCount=1,
     InstanceType='t2.micro',
     KeyName='xxxx' # ec2 instance olusturmak icin key i girmelisin
 )