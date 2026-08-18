#!/usr/bin/env bash
set -euo pipefail

echo "Terraform workload deployment is intentionally disabled in the mango node repository." >&2
echo "Use a stack repository with a scoped Proxmox API token and resource pool." >&2
exit 2
