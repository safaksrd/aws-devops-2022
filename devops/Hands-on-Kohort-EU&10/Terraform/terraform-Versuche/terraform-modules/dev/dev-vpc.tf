module "tf-vpc" {
  source = "../modules" #ust klasordeki modules klasorunu source olarak gosterdik, oradaki tf dosyalarini kullanacak
  environment = "DEV" # buradan sadece variable atiyoruz, bu ornekte environment variable ina DEV dedik. Olusacak olan VPC ve Subnet lerin sonunda DEV yazacak
  public_subnet_cidr = "10.0.5.0/24" # default degeri 10.0.1.0/24 idi
}

# output terminalde gorunen birsey oldugu icin, bu klasorun altinda istedigimiz output u girmemiz gerekiyor
# burada module den cektigimiz icin yazim farkli
# Normalde value = aws_vpc.module_vpc.cidr_block boyle yaziyorduk, ama burada farkli
output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr # Buradaki module.tf_vpc yi en ust satirdan aliyor, vpc_cidr i module klasorundeki outputs.tf den aliyor
}