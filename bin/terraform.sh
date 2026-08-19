#!/usr/bin/env bash
# Runs the platform Terraform in terraform/ with GitLab HTTP state auth.
# Sources .envrc (gitignored) for the Proxmox API token when present.
set -euo pipefail

GIT_ROOT=$(git rev-parse --show-toplevel)

if [[ -f "${GIT_ROOT}/.envrc" ]]; then
  # shellcheck disable=SC1091
  source "${GIT_ROOT}/.envrc"
fi

export TF_HTTP_USERNAME="${TF_HTTP_USERNAME:-${GITLAB_USER:-gitlab-ci-token}}"
export TF_HTTP_PASSWORD="${TF_HTTP_PASSWORD:-${GITLAB_ACCESS_TOKEN:-}}"

cd "${GIT_ROOT}/terraform"
terraform "$@"
