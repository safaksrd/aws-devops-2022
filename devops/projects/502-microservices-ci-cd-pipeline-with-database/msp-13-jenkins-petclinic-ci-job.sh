# Packaging using the docker container of maven
# on linux
docker run --rm -v $HOME/.m2:/root/.m2 -v `pwd`:/app -w /app maven:3.6-openjdk-11 mvn clean test

# on Windows on powershell
docker run --rm -v C:\Users\MrCall\.m2:/root/.m2 -v C:\Users\MrCall\call-git\spring-petclinic-microservices:/app -w /app maven:3.6-openjdk-11 mvn clean test