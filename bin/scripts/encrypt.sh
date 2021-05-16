#!/usr/local/bin/bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)

declare -a secrets

secrets+=(".envrc")
secrets+=("ansible/.vault_pass")
secrets+=("ansible/artifacts/kolla/passwords.yml")
secrets+=("terraform/admin/.envrc")
secrets+=("terraform/admin/terraform.tfstate")
secrets+=("terraform/admin/files/logins")
secrets+=("terraform/services/.envrc")
secrets+=("terraform/services/terraform.tfstate")

# TODO tar octavia and encrypt

echo ""
echo " #######################"
echo " ### Encrypt secrets ###"
echo " #######################"
echo ""

for secret in "${secrets[@]}";
do
    gpg --encrypt --recipient jakoberpf $GIT_ROOT/$secret
done
