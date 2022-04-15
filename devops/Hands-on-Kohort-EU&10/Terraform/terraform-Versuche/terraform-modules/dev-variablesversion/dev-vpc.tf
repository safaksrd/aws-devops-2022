module "tf-vpc" {
  source = "../modules" #ust klasordeki modules klasorunu source olarak gosterdik, oradaki tf dosyalarini kullanacak
  environment = var.env # variable a cevirdik, leon.auto.tfvars da girilmediyse variables.tf den default deger alacak
  public_subnet_cidr = var.public_subnet_cidr # variable a cevirdik, leon.auto.tfvars da girilmediyse variables.tf den default deger alacak
}

# output terminalde gorunen birsey oldugu icin, bu klasorun altinda istedigimiz output u girmemiz gerekiyor
# burada module den cektigimiz icin yazim farkli
# Normalde value = aws_vpc.module_vpc.cidr_block boyle yaziyorduk, ama burada farkli
output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr # Buradaki module.tf_vpc yi en ust satirdan aliyor, vpc_cidr i module klasorundeki outputs.tf den aliyor
}