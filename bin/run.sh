#!/bin/bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Create virtual environment
pyenv install 3.9.6
pyenv local 3.9.6 
python -m venv .venv

# Activate virtual environment
source .venv/bin/activate

# Install ansible
pip3 install --upgrade pip
pip3 install ansible==4.8.0

# Get roles from galaxy
ansible-galaxy install systemli.letsencrypt

# Get roles from repos
# TODO

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
# cd terraform/cloud
# terraform init
# terraform apply
# terraform apply # Apply terrafrom twice, because of zerotier bug
# cd $GIT_ROOT

echo "Bootstrapping Development Cluster SUCESSFULL"