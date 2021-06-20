#!/usr/local/bin/bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)

declare -a secrets

#secrets+=(".envrc")
secrets+=("ansible/.vault_pass")
secrets+=("ansible/artifacts/zerotier/identity.public")
secrets+=("ansible/artifacts/zerotier/identity.secret")
secrets+=("terraform/zerotier/.envrc")
secrets+=("terraform/zerotier/terraform.tfstate")
secrets+=("terraform/proxmox/.envrc")
secrets+=("terraform/proxmox/terraform.tfstate")

echo ""
echo " #######################"
echo " ### Decrypt secrets ###"
echo " #######################"
echo ""

for secret in "${secrets[@]}";
do
    echo $secret
    gpg -d -o $GIT_ROOT/$secret $GIT_ROOT/$secret.gpg  
done
