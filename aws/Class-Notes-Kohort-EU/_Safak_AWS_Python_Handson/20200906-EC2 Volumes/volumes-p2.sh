Ozet: 2020-09-06
#EC2 instance imiza AWS management konsol volumes bolumunden 2 GB volume daha ekleyelim, 
#sonra bu 2GB volume u iki partitiona bolelim. bu partitionlari formatlayalim, mount edelim.

# PART 2 - EXTEND EBS VOLUME WITH PARTITIONING
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
# https://www.tecmint.com/fdisk-commands-to-manage-linux-disk-partitions/

# list volumes to show current status, primary (root) and secondary volumes should be listed
lsblk

# show the used and available capacities related with volumes
df -h

# create tertiary volume (2 GB for this demo) in the same AZ with the instance on aws console
# attach the new volume from aws console, then list volumes again.
#  primary (root), secondary and tertiary volumes should be listed
lsblk

# show the used and available capacities related with volumes
df -h

# show the current partitions... use "fdisk -l /dev/xvda" for specific partition
# mevcut partition lari listeliyoruz. Son ekledigimiz xvdg 2 GB ve tek parca gorunuyor.
# xvdg yi 1 GB ve 1 GB seklinde iki partiton a bolecegiz
sudo fdisk -l

# check all available fdisk commands and using "m".
sudo fdisk /dev/xvdg # partiton islemlerini yapariz, sektor boyutlarini ayarlariz
# n -> add new partition (with 1G size)
# p -> primary
# Partition number: 1
# First sector: default - use Enter to select default
# Last sector: 2100000
# n -> add new partition (with rest of the size-1G)
# p -> primary
# Partition number: 2
# First sector: default - use Enter to select default
# Last sector: default - use Enter to select default
# w -> write partition table

# show new partitions
lsblk

# format the new partitions
sudo mkfs -t ext4 /dev/xvdg1
sudo mkfs -t ext4 /dev/xvdg2

# mount etmedigimiz surece df -h yazinca yeni volume u goremeyiz
df -h

# create a mounting point path for new volume
# Mount edecegimiz klasorleri olustur
sudo mkdir /mnt/3rd-vol-part1
sudo mkdir /mnt/3rd-vol-part2

# mount the new volume to the mounting point path
# mount ediyoruz
sudo mount /dev/xvdg1 /mnt/3rd-vol-part1/
sudo mount /dev/xvdg2 /mnt/3rd-vol-part2/

# Yanlis bir mount islemi yaparsak asagidaki komutla unmount yapabiliriz
# sudo unmount /dev/xvdg1 /mnt/3rd-vol-part1/
# sudo unmount /dev/xvdg2 /mnt/3rd-vol-part2/

# list volumes to show current status, all volumes and partittions should be listed
lsblk

# show the used and available capacities related with volumes and partitions
df -h

# if there is no data on it, create a new file to show persistence in later steps
sudo touch /mnt/3rd-vol-part2/guilewasalsohere.txt
ls -lh /mnt/3rd-vol-part2/

# modify the new (3rd) volume in aws console, and enlarge capacity 1 GB more (from 2GB to 3GB for this demo).
# AWS konsolda son eklenen volume u 2GB'den 3GB'e cikariyoruz

# check if the attached volume is showing the new capacity
lsblk

# show the real capacity used currently at mounting path, old capacity should be shown.
df -h

# extend the partition 2 and occupy all newly avaiable space
# xvdg nin 2 partition unu genisletme adimlari. 
# Once yeni eklenen 1 GB yi xvdg nin 2 numarali Partitionu icin isgal ediyoruz. Hangi partitionu genisletmek istiyorsak onun numarasini yaziyoruz.
sudo growpart /dev/xvdg 2

# ​show the real capacity used currently at mounting path, updated capacity should be shown.
lsblk

# resize and extend the file system
# 2 numarali partitona yeni eklenen 1 GB'i resize ile genisletiyoruz
sudo resize2fs /dev/xvdg2

# show the newly created file to show persistence
ls -lh /mnt/3rd-vol-part2/

# reboot and show that configuration is gone
# Mount islemleri bosa gitti
sudo reboot now
#############################
