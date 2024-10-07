#!/bin/bash

if [ -z "$(command -v debootstrap)" ]; then echo "debootstrap is not installed!"; exit 1; fi
if [ -z "$(command -v aarch64-linux-gnu-gcc)" ]; then echo "aarch64-linux-gnu-gcc is not installed!"; exit 1; fi
if [ -z "$(command -v flex)" ]; then echo "flex is not installed!"; exit 1; fi
if [ -z "$(command -v bison)" ]; then echo "bison is not installed!"; exit 1; fi
if [ -z "$(command -v bc)" ]; then echo "bc is not installed!"; exit 1; fi
if [ -z "$(command -v swig)" ]; then echo "swig is not installed!"; exit 1; fi

# jobs=$(nproc)
jobs=4

download() {
    name=$1
    dir=$2
    command=$3
    if [ ! -d "$dir" ]; then
        echo "Building $name..."
        $command
    else
        echo "Already downloaded $name"
    fi
}

config() {
    name=$1
    config_name=$2
    echo "Applying $name config..."
    sudo make -s ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- $config_name
}

build() {
    name=$1
    file=$2
    make_args=$3
    if [ ! -f "$file" ]; then
        echo "Building $name..."
        sudo make CROSS_COMPILE=aarch64-linux-gnu- $make_args -j$(jobs)
    else
        echo "$name Already built"
    fi
}

# Download Debian stable
download "Debian stable" "Derek-OS" "sudo debootstrap --foreign --arch=arm64 stable Derek-OS http://deb.debian.org/debian/"

# Download Linux source
download "Linux" "Linux" "git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git Linux"

# Download ARM Trusted Firmware source
download "ARM Trusted Firmware" "ARM-Trusted-Firmware" "git clone https://github.com/ARM-software/arm-trusted-firmware.git ARM-Trusted-Firmware"

# Download U-Boot source
download "U-Boot" "U-Boot" "git clone https://github.com/u-boot/u-boot.git U-Boot"

# Build required Linux files
cd Linux
config "Linux" "defconfig" # NOTE: may need adjusted slightly, or just copied from armbian
build "Linux DTB's" "arch/arm64/boot/Image" "Image"
cp arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dtb ..
build "Linux image" "arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dtb" "dtbs"
cp arch/arm64/boot/Image ..
cd ..

# Build required ARM Trusted Firmware files
cd ARM-Trusted-Firmware
build "ARM Trusted Firmware" "build/sun50i_a64/release/bl31.bin" "PLAT=sun50i_a64 DEBUG=0 bl31"
cp build/sun50i_a64/release/bl31.bin ../BL31.bin
cd ..

# Build required U-Boot files
cd U-Boot
config "U-Boot" "orangepi_zero3_defconfig"
build "U-Boot" "u-boot-sunxi-with-spl.bin" "BL31=../BL31.bin"
cp u-boot-sunxi-with-spl.bin ..
cd ..

echo "Done!"

# TODO: there may need to be a boot.scr file to point the U-Boot-with-SPL.bin file (changed back to original filename just in case)
# TODO: kernel config maybe