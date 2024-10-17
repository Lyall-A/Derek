#!/bin/bash
# Creates Derek OS

set -e

# NOTE: may be more dependencies needed for building
if [ -z "$(command -v debootstrap)" ]; then echo "debootstrap is not installed!"; exit 1; fi
if [ -z "$(command -v aarch64-linux-gnu-gcc)" ]; then echo "aarch64-linux-gnu-gcc is not installed!"; exit 1; fi
if [ -z "$(command -v flex)" ]; then echo "flex is not installed!"; exit 1; fi
if [ -z "$(command -v bison)" ]; then echo "bison is not installed!"; exit 1; fi
if [ -z "$(command -v bc)" ]; then echo "bc is not installed!"; exit 1; fi
if [ -z "$(command -v swig)" ]; then echo "swig is not installed!"; exit 1; fi

if [ -d "./Derek-OS" ]; then
    echo "Derek OS already exists, deleting it and continuing in 5 seconds..."
    sleep 5
    sudo umount ./Derek-OS/proc || true
    sudo umount ./Derek-OS/dev || true
    sudo umount ./Derek-OS/sys || true
    sudo rm -r ./Derek-OS
fi

# Download
source ./derek-os-download.sh

# Compile
source ./derek-os-compile.sh

# Prep Derek-OS directory
sudo mkdir -p ./Derek-OS
echo "Copying Debian files to Derek OS..."
sudo cp -r ./Debian/* ./Derek-OS
echo "Installing Linux Modules..."
sudo make -C ./Linux CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=../Derek-OS

# Setup
source ./derek-os-setup.sh

echo "Done!"