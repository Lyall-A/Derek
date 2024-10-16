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
    if [ -d "$dir" ]; then
        echo "$name already downloaded, removing..."
        sudo rm -r "$dir"
    fi
    echo "Downloading $name..."
    $command
}

download_git() {
    name=$1
    dir=$2
    repo=$3
    if [ -d "$dir" ]; then
        echo "$name already downloaded, attempting to update..."
        git -C "$dir" pull
    else
        echo "Downloading $name..."
        git clone --depth=1 --single-branch --no-tags $repo "$dir"
    fi
}

config() {
    name=$1
    config_name=$2
    make_args=$3
    echo "Setting $config_name as $name config..."
    sudo make -s CROSS_COMPILE=aarch64-linux-gnu- $make_args $config_name
}

build() {
    name=$1
    make_args=$2
    echo "Building $name..."
    sudo make CROSS_COMPILE=aarch64-linux-gnu- $make_args -j$jobs
}

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
    sudo rm -r ./Derek-OS
fi

# Download Debian stable
download "Derek OS (Debian stable)" "Debian" "sudo debootstrap --foreign --arch=arm64 stable Debian http://deb.debian.org/debian" # ca-certificates and curl is required for the Docker install

# Download Linux source
download_git "Linux" "Linux" "--branch linux-rolling-stable https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

# Download Trusted Firmware-A source
download_git "Trusted Firmware-A" "Trusted-Firmware-A" "https://review.trustedfirmware.org/TF-A/trusted-firmware-a.git"

# Download U-Boot source
download_git "U-Boot" "U-Boot" "https://source.denx.de/u-boot/u-boot.git"

# Build required Linux files
cd ./Linux
config "Linux" "defconfig" "ARCH=arm64" # TODO: maybe make custom config or steal somewhere else
build "Linux Image" "ARCH=arm64 Image"
cp arch/arm64/boot/Image ../Image
build "Linux Modules" "ARCH=arm64 modules"
build "Linux DTB's" "ARCH=arm64 dtbs"
cp arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dtb ../sun50i-h618-orangepi-zero3.dtb
cd ..

# Build required Trusted Firmware-A files
cd ./Trusted-Firmware-A
build "Trusted Firmware-A" "PLAT=sun50i_h616"
cp build/sun50i_h616/release/bl31.bin ../BL31.bin
cd ..

# Build required U-Boot files
cd ./U-Boot
config "U-Boot" "orangepi_zero3_defconfig"
build "U-Boot" "BL31=../BL31.bin"
cp u-boot-sunxi-with-spl.bin ../u-boot-sunxi-with-spl.bin
cd ..

# Setup Derek OS
sudo mkdir -p ./Derek-OS
sudo mkdir -p ./Derek-OS/Derek-OS-Temp

echo "Copying Debian files to Derek OS..."
sudo cp -r ./Debian/* ./Derek-OS

echo "Installing Linux Modules..."
sudo make -C ./Linux CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=../Derek-OS

echo "Copying necessary files to Derek OS..."
sudo cp -r ./Copy ./Derek-OS/Derek-OS-Temp
sudo cp ./apt-packages.txt ./Derek-OS/Derek-OS-Temp
sudo cp ./setup.sh ./Derek-OS/Derek-OS-Temp
sudo cp ./hostname ./Derek-OS/Derek-OS-Temp
sudo cp ./fstab ./Derek-OS/Derek-OS-Temp
sudo cp ./docker-compose.yml ./Derek-OS/Derek-OS-Temp
sudo cp ./first-boot.sh ./Derek-OS/Derek-OS-Temp
sudo cp ./first-boot.service ./Derek-OS/Derek-OS-Temp

echo "Starting binfmt..."
sudo systemctl start systemd-binfmt.service

echo "Mounting virtual directories..."
sudo mount --bind /proc ./Derek-OS/proc
sudo mount --bind /dev ./Derek-OS/dev
sudo mount --bind /sys ./Derek-OS/sys

# echo "Running second stage of debootstrap..."
# sudo chroot ./Derek-OS /debootstrap/debootstrap --second-stage

echo "Running setup script in chroot..."
sudo chmod +x ./Derek-OS/Derek-OS-Temp/setup.sh
sudo chroot ./Derek-OS /Derek-OS-Temp/setup.sh

echo "Unmounting virtual directories..."
sudo umount -l ./Derek-OS/proc || true
sudo umount -l ./Derek-OS/dev || true
sudo umount -l ./Derek-OS/sys || true

echo "Done!"

# TODO: boot.scr file?