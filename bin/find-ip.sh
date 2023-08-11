#!/usr/local/bin/bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)

arp -a | grep "40:b0:76:d7:f1:2a" # enp5s0 (10Gig)
arp -a | grep "40:b0:76:d7:f1:2b" # enp9s0 (1Gig)
