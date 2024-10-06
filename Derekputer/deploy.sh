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

echo "Downloading ARM Trusted Firmware source..."
git clone https://github.com/ARM-software/arm-trusted-firmware.git ARM-Trusted-Firmware

echo "Downloading U-Boot source..."
git clone https://github.com/u-boot/u-boot.git U-Boot

echo "Compiling ARM Trusted Firmware..."
cd ARM-Trusted-Firmware
make CROSS_COMPILE=aarch64-linux-gnu- PLAT=sun50i_a64 DEBUG=0 bl31 -j$(nproc)
cd ..

echo "Compiling U-Boot..."
cd U-Boot
make orangepi_zero3_defconfig
make CROSS_COMPILE=aarch64-linux-gnu- BL31=../ARM-Trusted-Firmware/build/sun50i_a64/release/bl31.bin -j$(nproc)
cp u-boot-sunxi-with-spl.bin ../U-Boot-with-SPL.bin
cd ..