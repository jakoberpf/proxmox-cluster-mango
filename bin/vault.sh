#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
ssh_dir="$repo_root/.ssh"
env_file="$ssh_dir/.env"

mkdir -p "$ssh_dir"
chmod 0700 "$ssh_dir"
trap 'rm -f "$env_file"' EXIT

# SSH Keys
cd "$ssh_dir"

vault2env CICD/global/ssh/automation "$env_file"
# shellcheck disable=SC1090
source "$env_file"

rm -f automation
printf '%s' "$PRIVAT_KEY_OPENSSH_PEM" | base64 --decode > automation
chmod 600 automation

rm -f automation.pub
printf '%s' "$PUBLIC_KEY_SSH" | base64 --decode > automation.pub
chmod 600 automation.pub
