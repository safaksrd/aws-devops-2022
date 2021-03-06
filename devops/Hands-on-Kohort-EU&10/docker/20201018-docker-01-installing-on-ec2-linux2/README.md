Ozet: 18/10/2020

- Docker uygulamayi altyapidan bagimsiz hale getirir. Boylece yazilim uretim ve dagitim sureci hizlanir.
- namespaces (process / network / mount) : 2000 li yillarin basinda linux cekirdegine eklendi. uygulamalarin cekirdek uzerinde izolasyonunu sagladi.
- control groups (C groups) : 2007'de Google muhendisleri ekledi. Processlerin kaynak kullanimini izole eder, kaynak kullanimini sinirlar.
- Konteynir icinde uygulamanin calismasi icin gerekli tum ek paketler var, ancak linux cekirdegiyle ilgili birsey yok. Bu sayede tek bir linux isletim sistemi uzerinde cekirdekten bagimsiz izole konteynirlar ortaya cikti.

- Image ler inmutable, image lardan uretilen container lar mutable (ihtiyaca gore ekleme yapabiliyoruz)
- docker daemon: docker engine: server
- docker CLI: client

- sudo yum update -y : Update the installed packages and package cache on your instance.
- sudo amazon-linux-extras install docker -y : Install the most recent Docker Community Edition package.
- sudo systemctl start docker : Start docker service.
- sudo systemctl enable docker : Enable docker service so that docker service can restart automatically after reboots.
- sudo systemctl status docker : Check if the docker service is up and running.
- sudo usermod -a -G docker ec2-user : Add the `ec2-user` to the `docker` group to run docker commands without using `sudo`.
- newgrp docker : Normally, the user needs to re-login into bash shell for the group `docker` to be effective, but `newgrp` command can be used activate `docker` group for `ec2-user`, not to re-login into bash shell.
- docker version : Check the docker version without `sudo`.

- docker pull nginx : pull komutu ile ilgili image i sadece pull eder, bu image dan konteynir uretmez.
- docker pull clarusways/cw_web_flask1 : dockerhub daki clarusways hesabi altindaki cw_web_flask1 isimli image i ceker, bu image dan konteynir uretmez.

- docker run -d -p 80:80 --name leon1 nginx : run komutu ile nginx isimli image i pull eder, bu image dan leon1 isimli bir konteynir calistirir. 
  -p 80:80 ile konteynir uzerindeki 80 portunu lokaldeki 80 portu uzerinden dis dunyaya expose eder. web browser da localhost:80 yazinca ilgili sayfa gorulur.

- docker run -d -p 90:5000 --name leon2 clarusways/cw_web_flask1 : dockerhub daki clarusways hesabi altindaki cw_web_flask1 isimli image i pull eder, bu image dan leon2 isimli bir konteynir calistirir. 
  -p 90:5000 ile konteynir uzerindeki 5000 portunu lokaldeki 90 portu uzerinden dis dunyaya expose eder. web browser da localhost:90 yazinca ilgili sayfa gorulur.

- docker inspect "CONTAINER ID ya da NAMES" : konteynir hk detayli bilgi verir
- docker images : lokaldeki docker image lari gosterir
- docker ps : lokalde calisan konteynir lari gosterir.
- docker ps -a : durdurulmus bile olsa calisan calismayan lokaldeki t??m konteynir lari gosterir.
- docker stop "CONTAINER ID ya da NAMES" : Calisan konteynir i durdurur. Konteyniri silmeden once durdurmaliyiz.
- docker start "CONTAINER ID ya da NAMES" : Duran konteynir i calistirir.
- docker rm "CONTAINER ID ya da NAMES" : Durdurulan konteynir i siler.
- docker exec -it "CONTAINER ID ya da NAMES" sh : sh shell ile interaktif mod da konteynir in icine baglanir. Kabul ederse sh yerine baska shell isimleri de yazabiliriz.
- Konteynirin icine girdikten sonra ps komutu ile calisan process ler gorulur. Ilk siradaki yani PID:1 konteynir icinde calisan uygulamadir.
- Konteynir icinde cat /etc/os-release komutu ile konteynirin isletim sistemi gorulebilir.


# Hands-on Docker-01 : Installing Docker on Amazon Linux 2 AWS EC2 Instance

Purpose of the this hands-on training is to teach the students how to install Docker on on Amazon Linux 2 EC2 instance.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install Docker on Amazon Linux 2 EC2 instance

- configure a Cloudformation template for creating a Docker machine

## Outline

- Part 1 - Launch Amazon Linux 2 EC2 Instance and Connect with SSH

- Part 2 - Install Docker on Amazon Linux 2 EC2 Instance

- Part 3 - Configure a Cloudformation Template for a Docker machine

## Part 1 - Launch Amazon Linux 2 EC2 Instance and Connect with SSH

- Launch an EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH connections.

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

## Part 2 - Install Docker on Amazon Linux 2 EC2 Instance

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Install the most recent Docker Community Edition package.

```bash
sudo amazon-linux-extras install docker -y
```

- Start docker service.

```bash
sudo systemctl start docker
```

- Enable docker service so that docker service can restart automatically after reboots.

```bash
sudo systemctl enable docker
```

- Check if the docker service is up and running.

```bash
sudo systemctl status docker
```

- Add the `ec2-user` to the `docker` group to run docker commands without using `sudo`.

```bash
sudo usermod -a -G docker ec2-user
```

- Normally, the user needs to re-login into bash shell for the group `docker` to be effective, but `newgrp` command can be used activate `docker` group for `ec2-user`, not to re-login into bash shell.

```bash
newgrp docker
```

- Check the docker version without `sudo`.

```bash
docker version

Client:
 Version:           19.03.6-ce
 API version:       1.40
 Go version:        go1.13.4
 Git commit:        369ce74
 Built:             Fri May 29 04:01:26 2020
 OS/Arch:           linux/amd64
 Experimental:      false

Server:
 Engine:
  Version:          19.03.6-ce
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.13.4
  Git commit:       369ce74
  Built:            Fri May 29 04:01:57 2020
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.3.2
  GitCommit:        ff48f57fc83a8c44cf4ad5d672424a98ba37ded6
 runc:
  Version:          1.0.0-rc10
  GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
```

- Check the docker info without `sudo`.

```bash
docker info

Client:
 Debug Mode: false

Server:
 Containers: 1
  Running: 0
  Paused: 0
  Stopped: 1
 Images: 2
 Server Version: 19.03.6-ce
 Storage Driver: overlay2
  Backing Filesystem: xfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: ff48f57fc83a8c44cf4ad5d672424a98ba37ded6
 runc version: dc9208a3303feef5b3839f4323d9beb36df0a9dd
 init version: fec3683
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 4.14.181-140.257.amzn2.x86_64
 Operating System: Amazon Linux 2
 OSType: linux
 Architecture: x86_64
 CPUs: 1
 Total Memory: 983.3MiB
 Name: ip-172-31-30-143.us-east-2.compute.internal
 ID: AK6G:E2CQ:G45L:SEJY:FH6K:Q2CX:MQC6:6WJV:NYH2:6WOQ:BLWZ:3I7F
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
```

# install docker-compose
```bash
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## Part 3 - Configure a Cloudformation Template for a Docker machine

- Write and configure a Cloudformation Template to have a Docker machine ready on Amazon Linux 2 EC2 Instance with security group allowing SSH connections from anywhere.

```yaml
AWSTemplateFormatVersion: 2010-09-09

Description: >
  This Cloudformation Template creates a Docker machine on EC2 Instance.
  Docker Machine will run on Amazon Linux 2 (ami-026dea5602e368e96) EC2 Instance with
  custom security group allowing SSH connections from anywhere on port 22.

Parameters:
  KeyPairName:
    Description: Enter the name of your Key Pair for SSH connections.
    Type: String
    Default: leon

Resources:
  DockerMachineSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable SSH for Docker Machine
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
  DockerMachine:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0e1d30f2c40c4c701
      InstanceType: t2.micro
      KeyName: !Ref KeyPairName
      SecurityGroupIds:
        - !GetAtt DockerMachineSecurityGroup.GroupId
      Tags:
        -
          Key: Name
          Value: !Sub Docker Machine of ${AWS::StackName}
      UserData:
        Fn::Base64: |
          #! /bin/bash
          yum update -y
          amazon-linux-extras install docker -y
          systemctl start docker
          systemctl enable docker
          usermod -a -G docker ec2-user
          # install docker-compose
          curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
          -o /usr/local/bin/docker-compose
          chmod +x /usr/local/bin/docker-compose
Outputs:
  WebsiteURL:
    Description: Docker Machine DNS Name
    Value: !Sub
      - ${PublicAddress}
      - PublicAddress: !GetAtt DockerMachine.PublicDnsName
```
