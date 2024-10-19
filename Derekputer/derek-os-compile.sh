#!/bin/bash
# Compiles everything needed for Derek OS

set -e

jobs=$(nproc)

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

# Build required Linux files
cd ./Linux
sudo cp ../derekputer.config .config
config "Linux" "olddefconfig" "ARCH=arm64"
build "Linux Image" "ARCH=arm64 Image"
build "Linux Modules" "ARCH=arm64 modules"
build "Linux DTB's" "ARCH=arm64 dtbs"
cd ..

# Build required Trusted Firmware-A files
cd ./Trusted-Firmware-A
build "Trusted Firmware-A" "PLAT=sun50i_h616"
cd ..

# Build required U-Boot files
cd ./U-Boot
config "U-Boot" "orangepi_zero3_defconfig"
build "U-Boot" "BL31=../Trusted-Firmware-A/build/sun50i_h616/release/bl31.bin"
cd ..