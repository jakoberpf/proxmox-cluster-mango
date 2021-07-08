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
secrets+=("terraform/openstack/.envrc")
secrets+=("terraform/openstack/terraform.tfstate")
secrets+=("terraform/kubernetes/.envrc")
secrets+=("terraform/kubernetes/terraform.tfstate")

echo ""
echo " #######################"
echo " ### Encrypt secrets ###"
echo " #######################"
echo ""

for secret in "${secrets[@]}";
do
    gpg --encrypt --yes --recipient jakoberpf $GIT_ROOT/$secret
done
