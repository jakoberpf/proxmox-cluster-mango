#!/usr/bin/env bash
set -euo pipefail

mango_mac="40:b0:76:d7:f1:2a"

if command -v wakeonlan >/dev/null 2>&1; then
  wakeonlan "$mango_mac"
elif command -v etherwake >/dev/null 2>&1; then
  etherwake "$mango_mac"
else
  echo "Install wakeonlan or etherwake before using this helper." >&2
  exit 2
fi
