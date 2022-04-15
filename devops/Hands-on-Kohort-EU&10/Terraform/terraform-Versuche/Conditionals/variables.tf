variable "ec2_ami" {
  default = "ami-03ededff12e34e59e"
}
variable "ec2_type" {
  default = "t2.micro"
}
variable "ec2_key_name" {
  default = "leon"
}
variable "ec2_number" {
  default = 1
}
variable "tf-tags" {
  type = list(string)
  default = ["jenkins-1", "jenkins-2", "jenkins-3", "jenkins-4"]
}

