#!/bin/bash

if [ -z "$(command -v debootstrap)" ]; then
    echo "debootstrap is not installed!"
    exit 1
fi

if [ -z "$(command -v aarch64-linux-gnu-gcc)" ]; then
    echo "aarch64-linux-gnu-gcc is not installed!"
    exit 1
fi

echo "Downloading Debian stable..."
sudo debootstrap --foreign --arch=arm64 stable Derek-OS

echo "Downloading U-Boot source..."
git clone https://github.com/u-boot/u-boot.git U-Boot
cd U-Boot

echo "Compiling U-Boot..."
make orangepi_zero3_defconfig
make CROSS_COMPILE=aarch64-linux-gnu- -j $(nproc)