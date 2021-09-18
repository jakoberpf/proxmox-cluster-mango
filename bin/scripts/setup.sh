#!/usr/local/bin/bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Create virtual environment
pyenv local 3.9.6 
virtualenv .venv

# Activate virtual environment
source .venv/bin/activate

# Install ansible
pip install ansible