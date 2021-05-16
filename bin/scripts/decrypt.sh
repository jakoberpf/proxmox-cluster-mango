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

# TODO dencrypt nad untar octavia

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
