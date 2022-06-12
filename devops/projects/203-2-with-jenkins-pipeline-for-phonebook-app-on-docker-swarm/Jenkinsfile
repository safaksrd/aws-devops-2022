pipeline {
    agent any
    environment{
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        // returnStdout:true).trim() sag ve sol taraftaki fazlaliklari trasliyor ve PATH e ekleme yapiyoruz
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID=sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        // AWS Account ID yi cekiyor
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        // ECR repo isminin ön kismi
        APP_REPO_NAME = "leon-repo/phonebook-app"
        // ECR repo isminin arka kismi
        APP_NAME = "phonebook"
        AWS_STACK_NAME = "leon-Phonebook-App-${BUILD_NUMBER}"
        // hatali bir stack silerken bir baska stack ayaga kaldirmamiz gerekebilir, sonuna BUILD_NUMBER env variable i ekleyerek cakismayi engeleriz
        CFN_TEMPLATE="phonebook-docker-swarm-cfn-template.yml"
        // github reponun altinda bu isimle bulacagi template i infrastructure i ayaga kaldirmak icin kullanacak
        CFN_KEYPAIR="leon"
        HOME_FOLDER = "/home/ec2-user"
        GIT_FOLDER = sh(script:'echo ${GIT_URL} | sed "s/.*\\///;s/.git$//"', returnStdout:true).trim()
        // traslama karakter degistirme yapiliyor, regex!

    }

    stages {
        stage('creating ECR Repository') {
            steps {
                echo 'creating ECR Repository'
                sh """
                aws ecr create-repository \
                  --repository-name ${APP_REPO_NAME} \
                  --image-scanning-configuration scanOnPush=false \
                  --image-tag-mutability MUTABLE \
                  --region ${AWS_REGION}
                """
                // coklu satir oldugu icin 3 lü tirnak kullandik
            }
        }
        stage('building Docker Image') {
            steps {
                echo 'building Docker Image'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:latest" .'
                // Jenkins server da -> jenkins in trigger olacagi github adresimizi ve jenkinsfile'in bulundugu directory'yi tanimladigimiz icin 
                // sonda . koyunca olusturdugumuz image github a konmus oluyor
                // Github ayari yapilmasaydi build edilen image jenkins kurulu makinede var/lib/jenkins/workspace klasorune giderdi
                sh 'docker image ls'
            }
        }
        stage('pushing Docker image to ECR Repository'){
            steps {
                echo 'pushing Docker image to ECR Repository'
                sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                // docker a giris credential i
                sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
                // image push ediliyor

            }
        }
        stage('creating infrastructure for the Application') {
            steps {
                echo 'creating infrastructure for the Application'
                sh "aws cloudformation create-stack --region ${AWS_REGION} --stack-name ${AWS_STACK_NAME} --capabilities CAPABILITY_IAM --template-body file://${CFN_TEMPLATE} --parameters ParameterKey=KeyPairName,ParameterValue=${CFN_KEYPAIR}"
                // CLI dan cloud formation i calistiran komut
                // stack olustururken "I acknowledge that AWS Cloudformation might create IAM resources" kismi tikleniyordu
                // capabilities kisminda bunu sagliyoruz
                // ParameterKey=KeyPairName bu deger phonebook-docker-swarm-cfn-template.yml daki parameters kismindaki ile ayni olmali
                // CFN_KEYPAIR i yukarida env var olarak tanimlandi, oradan aliyor
            
            script { // bir sonraki stage e gecmeden once cloud formation in ayaga kalkip kalkmadigini asagidaki script ile (PUBLIC IP olusmus mu olusmamis mi diye bakarak) kontrol ediyoruz. Dileyen 5-6 dakikalik sleep de koyabilir
                while(true) {
                        echo "Docker Grand Master is not UP and running yet. Will try to reach again after 10 seconds..."
                        sleep(10)

                        ip = sh(script:'aws ec2 describe-instances --region ${AWS_REGION} --filters Name=tag-value,Values=docker-grand-master Name=tag-value,Values=${AWS_STACK_NAME} --query Reservations[*].Instances[*].[PublicIpAddress] --output text | sed "s/\\s*None\\s*//g"', returnStdout:true).trim()
                        // docker grand master in ayaga kalkip kalmadigini kontrol ediyoruz. Makine ayaga kalkiyorsa public IP alir. Bu IP nin degeri en dusuk 0.0.0.0 yani 7 karakter olabilir
                        if (ip.length() >= 7) {
                            echo "Docker Grand Master Public Ip Address Found: $ip"
                            env.MASTER_INSTANCE_PUBLIC_IP = "$ip" // eger grand master ayaga kalkmis ise IP si olusmus demektir ve bu IP yi alir MASTER_INSTANCE_PUBLIC_IP isimli bir env variable a atar
                            break
                        }
                    }
                }
            }
        }
        stage('Test the infrastructure') { // Docker Swarm hazir mi diye visualizer programinin calisip calismadigini kontrol edecegiz. Docker Swarm kuruluysa visualizer calisir
            steps {
                echo "Testing if the Docker Swarm is ready or not, by checking Viz App on Grand Master with Public Ip Address: ${MASTER_INSTANCE_PUBLIC_IP}:8080"
            script {
                while(true) { // try blogunda sirali halde yazili komutlardan biri calismaz ise catch bloguna gecer. 5 saniye bekler ve tekrar try bloguna girer. try blogu basariliysa break ile cikar
                    try {
                      sh "curl -s --connect-timeout 60 ${MASTER_INSTANCE_PUBLIC_IP}:8080" // 60 saniye visualizer a baglanmaya calisiyor
                      echo "Successfully connected to Viz App."
                      break
                    }
                    catch(Exception) {
                      echo 'Could not connect Viz App'
                      sleep(5)   
                    }
                }
            }
        }
    }

        stage('Deploying the Application'){ // jenkinsfile icinden grand master a baglanmak gerekiyor
            environment {
                MASTER_INSTANCE_ID=sh(script:'aws ec2 describe-instances --region ${AWS_REGION} --filters Name=tag-value,Values=docker-grand-master Name=tag-value,Values=${AWS_STACK_NAME} --query Reservations[*].Instances[*].[InstanceId] --output text', returnStdout:true).trim() // burada grand master in instance id sini cekiyor ve environment variable olarak ayarliyoruz
            }
            steps { // Grand master instance id sini kullanarak docker Swarm i ayaga kaldirdigimiz step
                echo "Cloning and Deploying App on Swarm using Grand Master with Instance Id: $MASTER_INSTANCE_ID"
                sh 'mssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no --region ${AWS_REGION} ${MASTER_INSTANCE_ID} git clone ${GIT_URL}' // mssh ile grand master a key olmadan baglanir ve arkasina yazilan git clone komutunu shell de calistirir. default env variable olan GIT_URL adresindekileri clone eder
                sleep(10)
                sh 'mssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no --region ${AWS_REGION} ${MASTER_INSTANCE_ID} docker stack deploy --with-registry-auth -c ${HOME_FOLDER}/${GIT_FOLDER}/docker-compose.yml ${APP_NAME}' // docker-compose.yml calistirilarak Docker swarm ayaga kalkar
                // Swarm kuruldu. Worker ve Manager larin Swarm a dahil edilme islemi icin token alma islemi phonebook-docker-swarm-cfn-template.yml daki launch template ile yapilir
            }
        }
    }
    post {
        always { // her seferinde jenkins in hostunda olusan image i siliyoruz
            echo 'Deleting all local images'
            sh 'docker image prune -af'
        }
        failure {  // hata oliursa cakisma olmamasi icin ECR repoyu ve cloud formation stack i siliyoruz
            echo 'Delete the Image Repository on ECR due to the Failure'
            sh """
                aws ecr delete-repository \
                  --repository-name ${APP_REPO_NAME} \
                  --region ${AWS_REGION}\
                  --force
                """
            echo 'Deleting Cloudformation Stack due to the Failure'
            sh 'aws cloudformation delete-stack --region ${AWS_REGION} --stack-name ${AWS_STACK_NAME}'
        }
        success {
            echo 'You are the man/woman...'
        }
    }
}