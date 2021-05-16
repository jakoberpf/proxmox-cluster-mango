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

cd ansible/artifacts/octavia/
tar -cf client_ca.tar.xz client_ca
tar -cf server_ca.tar.xz server_ca
cd $GIT_ROOT

secrets+=("ansible/artifacts/octavia/client_ca.tar.xz")
secrets+=("ansible/artifacts/octavia/server_ca.tar.xz")

echo ""
echo " #######################"
echo " ### Encrypt secrets ###"
echo " #######################"
echo ""

for secret in "${secrets[@]}";
do
    gpg --encrypt --recipient jakoberpf $GIT_ROOT/$secret
done

cd ansible/artifacts/octavia/
rm client_ca.tar.xz
rm server_ca.tar.xz
cd $GIT_ROOT
