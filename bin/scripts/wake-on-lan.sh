#!/usr/local/bin/bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)

# https://www.myworkroom.de/p-hb:wakeonlan.proxmox
# https://www.cyberciti.biz/faq/apple-os-x-wake-on-lancommand-line-utility/

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Running on ${machine}"

case ${machine} in
  Linux)
    apt-get install etherwake
    etherwake 40:b0:76:d7:f1:2a
    ;;

  Mac)  
    brew install wakeonlan
    wakeonlan 40:b0:76:d7:f1:2a
    ;;

  *)
    echo "UNKNOWN:${unameOut}"
    ;;
esac
