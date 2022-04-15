variable "tf-ami" {
  type = list(string) # belirtmezsek sorun olmuyor
  default = ["ami-03ededff12e34e59e", "ami-04505e74c0741db8d", "ami-0b0af3577fe5e3532"]
}

variable "tf-tags" {
  type = list(string)
  default = ["aws-linux-2", "ubuntu-20.04", "red-hat-linux-8"]
}