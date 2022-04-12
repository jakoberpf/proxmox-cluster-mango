#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# # Create virtual environment
# pyenv install 3.9.6
# pyenv local 3.9.6 
# python -m venv .venv

# # Activate virtual environment
# source .venv/bin/activate

# # Install ansible
# pip3 install --upgrade pip
# pip3 install ansible==4.8.0

# # Get roles from galaxy
# ansible-galaxy install systemli.letsencrypt

# Run terraform apply
cd $GIT_ROOT/ansible

# Make sure virtual environment is activated
source .venv/bin/activate

# Run ansible
ansible-playbook plays/main.yaml
