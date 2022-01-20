Ozet: 2020-09-06

# EC2 instance a AWS konsol volumes bolumunden volume eklersek, 
# bu volumun EC2 daki Linux tarafindan gorulmesi icin terminalden bazi Linux 
# komutlari girmemiz gerekiyor.

# PART 1 - EXTEND EBS VOLUME WITHOUT PARTITIONING
# launch an instance from aws console
# check volumes which volumes attached to instance. 
# only root volume should be listed
lsblk # # volume attach etmeden once instance daki volumelari gorelim.

# create a new volume in the same AZ with the instance from aws console (2 GB for this demo).
# attach the new volume from aws console, then list block storages again.
# root volume and secondary volume should be listed
# Intstance a volume attach etmek istiyorsak instance ile volume ayni AZ de olusturulmali
# Konsolda olusturulan volume konsoldaki Actions bolumunden attach edilir
lsblk # # volume attach ettikten sonra instance daki volumelari gorelim.

# check if the attached volume is already formatted or not and has data on it.
sudo file -s /dev/xvdf # volume formatina bakiyoruz

# if not formatted, format the new volume
sudo mkfs -t ext4 /dev/xvdf # volume linux formati olan ext4 ile formatlandi

# check the format of the volume again after formatting
sudo file -s /dev/xvdf

# create a mounting point path for new volume
sudo mkdir /mnt/2nd-vol # yeni volume u attach edebilmemiz icin mnt klasoru altinda yeni dosya olusturduk. 
                        # Linux dosya mimarisine gore diskler mnt altinda oluyor

cd /mnt/2nd-vol/ # yeni olusturdugumuz dosyaya giriyoruz
ls # kontrol ediyoruz. lost+found gormemiz normal
cd # home klasore geri donuyoruz

# mount the new volume to the mounting point path
sudo mount /dev/xvdf /mnt/2nd-vol/ # formatladigimiz volumu, 
                                # yeni olusturdugumuz 2nd-vol klasorune mount ettik

# check if the attached volume is mounted to the mounting point path
lsblk # yeni volume mount edilmis hali ile gozukuyor

# show the available space, on the mounting point path
df # instance a bagli volumelar listeleniyor

# show the available space, on the mounting point path (human readable)
df -h # instance a bagli volumelar daha readable listeleniyor

# check if there is data on it or not.
ls -lh /mnt/2nd-vol/

# if there is no data on it, create a new file to show persistence in later steps
cd /mnt/2nd-vol
sudo touch guilewashere.txt # dosya olusturduk, ve icinde bilgi yazarak volume uzerinde islem yapabildigimizi gorduk
ls # kontrol ediyoruz

# modify the new volume in aws console, and enlarge capacity to double gb (from 2GB to 4GB for this demo).
# check if the attached volume is showing the new capacity
# AWS console uzerinden volume size'i Actions dan 2 gb den 4 GBye modify ettik. Volume u resize edecegiz.
lsblk # volumun 2'den 4'e ciktigini goruruz.

# show the real capacity used currently at mounting path, old capacity should be shown.
df -h # 2'den 4'e ciktigi gorulmuyor, resize yapmaliyiz

# resize the file system on the new volume to cover all available space.
sudo resize2fs /dev/xvdf # kapasitesini artirdigimiz volumun, yeni eklenen kismini formatladik

# show the real capacity used currently at mounting path, new capacity should reflect the modified volume size.
df -h # /dev/xvdf 2GB den 4GB e cikti

# show that the data still persists on the newly enlarged volume.
ls -lh /mnt/2nd-vol/

# show that mounting point path will be gone when instance rebooted 
sudo reboot now # EC2 instance i reboot edince instance ayni IP ile aciliyor
# yeniden baslatinca yaptigimiz ayarlar yok oldu. 
# Mount islemleri bosa gitti
# Ancak 8+4 GB volume duruyor ve tekrar formatlamaya gerek yok. 
# sadece mountu yeniden yapacagiz "sudo mount /dev/xvdf /mnt/2nd-vol/". 
# Ancak bunun cozumu var. volumes-p3.sh a bak.

# show the new volume is still attached, but not mounted
lsblk

# reboot edince 4 GB volume u tekrar mount etmeliyiz. Yoksa df -h da gorunmuyor
df -h

# check if the attached volume is already formatted or not and has data on it.
sudo file -s /dev/xvdf # volume formatina bakiyoruz

# mount the new volume to the mounting point path
sudo mount /dev/xvdf /mnt/2nd-vol/ # volumu, yeni olusturdugumuz 2nd-vol klasorune mount ettik

# show the used and available capacity is same as the disk size.
lsblk # yeni volume mount edilmis hali ile gozukuyor
df -h # instance a bagli volumelar daha readable listeleniyor

# if there is data on it, check if the data still persists.
ls -lh /mnt/2nd-vol/