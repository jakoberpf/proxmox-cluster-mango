#!/usr/local/bin/bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)

declare -a secrets

secrets+=(".envrc")
secrets+=("ansible/.vault_pass")
secrets+=("terraform/admin/.envrc")
secrets+=("terraform/terraform.tfstate")

echo ""
echo " #######################"
echo " ### Encrypt secrets ###"
echo " #######################"
echo ""

for secret in "${secrets[@]}";
do
    gpg --encrypt --yes --recipient jakoberpf $GIT_ROOT/$secret
done
