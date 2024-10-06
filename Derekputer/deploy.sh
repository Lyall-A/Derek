#!/bin/bash

if [ -z "$(command -v debootstrap)" ]; then
    echo "debootstrap is not installed!"
    exit 1
fi

if [ -z "$(command -v aarch64-linux-gnu-gcc)" ]; then
    echo "aarch64-linux-gnu-gcc is not installed!"
    exit 1
fi

jobs=$(nproc)

echo "Downloading Debian stable..."
sudo debootstrap --foreign --arch=arm64 stable Derek-OS

echo "Downloading Linux source..."
git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git Linux    

echo "Downloading ARM Trusted Firmware source..."
git clone https://github.com/ARM-software/arm-trusted-firmware.git ARM-Trusted-Firmware

echo "Downloading U-Boot source..."
git clone https://github.com/u-boot/u-boot.git U-Boot

echo "Building Linux uncompressed kernel image and device tree blobs..."
cd Linux
make ARCH=arm64 defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image dtbs -j$(jobs)
cp arch/arm64/boot/Image ../Image
cp arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dtb ../sun50i-h618-orangepi-zero3.dtb

echo "Building ARM Trusted Firmware..."
cd ARM-Trusted-Firmware
make CROSS_COMPILE=aarch64-linux-gnu- PLAT=sun50i_a64 DEBUG=0 bl31 -j$(jobs)
cp build/sun50i_a64/release/bl31.bin ../BL31.bin
cd ..

echo "Building U-Boot..."
cd U-Boot
make orangepi_zero3_defconfig
make CROSS_COMPILE=aarch64-linux-gnu- BL31=../BL31.bin -j$(jobs)
cp u-boot-sunxi-with-spl.bin ../U-Boot-with-SPL.bin
cd ..

# TODO: there may need to be a boot.scr file to point the U-Boot-with-SPL.bin file