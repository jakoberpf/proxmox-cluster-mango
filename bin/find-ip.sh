#!/usr/bin/env bash
set -euo pipefail

arp -a | grep -E "40:b0:76:d7:f1:2[ab]" || true
