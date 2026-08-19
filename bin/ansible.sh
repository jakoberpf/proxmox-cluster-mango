#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
mode=${1:-check}

if [[ -f "$repo_root/.venv/ansible/bin/activate" ]]; then
  # shellcheck disable=SC1091
  source "$repo_root/.venv/ansible/bin/activate"
fi

cd "$repo_root/ansible"

case "$mode" in
  syntax)
    ansible-playbook plays/main.yaml --syntax-check
    ansible-playbook plays/audit.yaml --syntax-check
    ansible-playbook plays/ceph_rgw.yml --syntax-check
    ansible-playbook plays/proxy.yml --syntax-check
    ansible-playbook plays/gpu_passthrough.yml --syntax-check
    ansible-playbook plays/wakeonlan.yml --syntax-check
    ;;
  audit)
    ansible-playbook plays/audit.yaml --limit mango
    ;;
  check)
    ansible-playbook plays/main.yaml --check --diff --limit mango
    ;;
  rgw-audit)
    ansible-playbook plays/ceph_rgw.yml --limit mango -e mango_rgw_phase=audit
    ;;
  rgw-check)
    rgw_phase=${RGW_PHASE:-audit}
    ansible-playbook plays/ceph_rgw.yml --check --diff --limit mango \
      -e "mango_rgw_phase=$rgw_phase"
    ;;
  proxy-check)
    ansible-playbook plays/proxy.yml --check --diff --limit mango
    ;;
  proxy-apply)
    if [[ ${PROXY_CONFIRM:-} != mango-proxy ]]; then
      echo "Refusing proxy apply: set PROXY_CONFIRM=mango-proxy after reviewing proxy-check." >&2
      exit 2
    fi
    ansible-playbook plays/proxy.yml --diff --limit mango \
      -e mango_proxy_confirm=mango-proxy
    ;;
  apply)
    if [[ ${CONFIRM:-} != mango ]]; then
      echo "Refusing apply: set CONFIRM=mango after reviewing check mode." >&2
      exit 2
    fi
    ansible-playbook plays/main.yaml --diff --limit mango
    ;;
  *)
    echo "Usage: $0 {syntax|audit|check|apply|rgw-audit|rgw-check|proxy-check|proxy-apply}" >&2
    exit 2
    ;;
esac
