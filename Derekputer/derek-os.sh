#!/bin/bash
# Creates Derek OS

set -e

password="Derek1234*"
# jobs=$(nproc)
jobs=8

download() {
    name=$1
    dir=$2
    command=$3
    if [ ! -d "$dir" ]; then
        echo "Downloading $name..."
        $command
    else
        echo "Already downloaded $name"
    fi
}

download_git() {
    name=$1
    dir=$2
    repo=$3
    if [ ! -d "$dir" ]; then
        echo "Downloading $name..."
        git clone --depth=1 --single-branch --no-tags $repo $dir
    else
        echo "Updating $name..."
        git -C $dir pull
    fi
}

config() {
    name=$1
    make_args=$2
    config_name=$3
    echo "Applying $name config..."
    sudo make -s CROSS_COMPILE=aarch64-linux-gnu- $make_args $config_name
}

build() {
    name=$1
    file=$2
    make_args=$3
    if [ ! -f "$file" ]; then
        echo "Building $name..."
        sudo make CROSS_COMPILE=aarch64-linux-gnu- $make_args -j$jobs
    else
        echo "$name already built"
    fi
}

# NOTE: may be more dependencies needed for building
if [ -z "$(command -v debootstrap)" ]; then echo "debootstrap is not installed!"; exit 1; fi
if [ -z "$(command -v aarch64-linux-gnu-gcc)" ]; then echo "aarch64-linux-gnu-gcc is not installed!"; exit 1; fi
if [ -z "$(command -v flex)" ]; then echo "flex is not installed!"; exit 1; fi
if [ -z "$(command -v bison)" ]; then echo "bison is not installed!"; exit 1; fi
if [ -z "$(command -v bc)" ]; then echo "bc is not installed!"; exit 1; fi
if [ -z "$(command -v swig)" ]; then echo "swig is not installed!"; exit 1; fi

# Download Debian stable
download "Derek OS (Debian stable)" "Debian" "sudo debootstrap --foreign --arch=arm64 stable Debian http://deb.debian.org/debian"

# Download Linux source
download_git "Linux" "Linux" "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

# Download ARM Trusted Firmware source
download_git "ARM Trusted Firmware" "ARM-Trusted-Firmware" "https://github.com/ARM-software/arm-trusted-firmware.git"

# Download U-Boot source
download_git "U-Boot" "U-Boot" "https://github.com/u-boot/u-boot.git"

# Build required Linux files
cd ./Linux
config "Linux" "ARCH=arm64" "defconfig" # NOTE: may need adjusted slightly, or just copied from armbian
build "Linux Image" "arch/arm64/boot/Image" "ARCH=arm64 Image"
cp arch/arm64/boot/Image ..
build "Linux DTB's" "arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dtb" "ARCH=arm64 dtbs"
cp arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dtb ..
cd ..

# Build required ARM Trusted Firmware files
cd ./ARM-Trusted-Firmware
build "ARM Trusted Firmware" "build/sun50i_a64/release/bl31.bin" "PLAT=sun50i_a64 DEBUG=0 bl31"
cp build/sun50i_a64/release/bl31.bin ../BL31.bin
cd ..

# Build required U-Boot files
cd ./U-Boot
config "U-Boot" "orangepi_zero3_defconfig"
build "U-Boot" "u-boot-sunxi-with-spl.bin" "BL31=../BL31.bin"
cp u-boot-sunxi-with-spl.bin ..
cd ..

# Setup Derek OS
sudo mkdir ./Derek-OS
cd ./Derek-OS
echo "Copying Debian files to Derek OS..."
sudo cp -r ../Debian/* .

echo "Starting binfmt..."
sudo systemctl start systemd-binfmt.service

echo "Mounting..."
sudo mount --mkdir --bind ../ ./mnt
sudo mount --bind /dev ./dev
sudo mount --bind /proc ./proc
sudo mount --bind /sys ./sys
sudo mount --bind /run ./run

echo "Running setup script in chroot..."
sudo chmod +x ../setup.sh
sudo chroot . /mnt/setup.sh

echo "Unmounting..."
sudo umount ./mnt
sudo umount ./dev
sudo umount ./proc
sudo umount ./sys
sudo umount ./run

cd ..

echo "Done!"

# TODO: there may need to be a boot.scr file to point the U-Boot-with-SPL.bin file (changed back to original filename just in case)
# TODO: kernel config maybe