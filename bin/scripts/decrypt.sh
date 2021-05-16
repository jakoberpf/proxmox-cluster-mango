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
secrets+=("ansible/artifacts/octavia/client_ca.tar.xz")
secrets+=("ansible/artifacts/octavia/server_ca.tar.xz")

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

cd ansible/artifacts/octavia/
rm -rf client_ca
tar -xf client_ca.tar.xz client_ca
rm client_ca.tar.xz
rm -rf server_ca
tar -xf server_ca.tar.xz server_ca
rm server_ca.tar.xz
cd $GIT_ROOT