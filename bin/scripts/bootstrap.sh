#!/usr/local/bin/bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)

# Run preparation terraform
cd terraform/zerotier
terraform init
terraform apply
cd $GIT_ROOT

# Run proxmox cluster ansible
cd ansible
ansible-playbook plays/main.yaml
cd $GIT_ROOT

# Run static infra terraform

# Run cloud infra terraform
cd terraform/cloud
terraform init
terraform apply
terraform apply # Apply terrafrom twice, because of zerotier bug
cd $GIT_ROOT

echo "Bootstrapping Development Cluster SUCESSFULL"