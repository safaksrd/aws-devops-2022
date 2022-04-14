output "instance-public-ip1" {
  value = aws_instance.tf-ec2-1.public_ip
}

output "instance-public-ip2" {
  value =aws_instance.tf-ec2-2.public_ip
}