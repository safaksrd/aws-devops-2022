# create-qa-automation-env-with-docker-swarm

# Environment Variables
PATH="$PATH:/usr/local/bin"
APP_NAME="Petclinic"
CFN_KEYPAIR="call-ansible.key"
CFN_TEMPLATE="./infrastructure/docker-swarm-infrastructure-cfn-template.yml"
AWS_REGION="us-east-1"
export ANSIBLE_PRIVATE_KEY_FILE="${WORKSPACE}/${CFN_KEYPAIR}"
export ANSIBLE_HOST_KEY_CHECKING=False
export APP_STACK_NAME="Call-$APP_NAME-App-${BUILD_NUMBER}"

# Create key pair for `ansible` using AWS CLI
aws ec2 create-key-pair --region ${AWS_REGION} --key-name ${CFN_KEYPAIR} --query "KeyMaterial" --output text > ${CFN_KEYPAIR}
chmod 400 ${CFN_KEYPAIR}

# Create Docker Swarm infrastructure with AWS Cloudformation using AWS CLI
aws cloudformation create-stack --region ${AWS_REGION} --stack-name ${APP_STACK_NAME} --capabilities CAPABILITY_IAM --template-body file://${CFN_TEMPLATE} --parameters ParameterKey=KeyPairName,ParameterValue=${CFN_KEYPAIR}

# Setup a Docker Swarm environment
# Update dynamic environment
sed -i "s/APP_STACK_NAME/$APP_STACK_NAME/" ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yaml
# Swarm Setup for all nodes (instances)
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yaml -b ./ansible/playbooks/pb_setup_for_all_docker_swarm_instances.yaml
# Swarm Setup for Grand Master node
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yaml ./ansible/playbooks/pb_initialize_docker_swarm.yaml
# Swarm Setup for Other Managers nodes
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yaml ./ansible/playbooks/pb_join_docker_swarm_managers.yaml
# Swarm Setup for Workers nodes
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yaml ./ansible/playbooks/pb_join_docker_swarm_workers.yaml

# Tear down the Docker Swarm infrastructure using AWS CLI
aws cloudformation delete-stack --region ${AWS_REGION} --stack-name ${AWS_STACK_NAME}

# Delete existing key pair using AWS CLI
aws ec2 delete-key-pair --region ${AWS_REGION} --key-name ${CFN_KEYPAIR}