#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
venv_dir="$repo_root/.venv/ansible"

python3 -m venv "$venv_dir"
# shellcheck disable=SC1091
source "$venv_dir/bin/activate"
python -m pip install --upgrade pip
python -m pip install -r "$repo_root/requirements.txt"
pre-commit install
