#!/bin/bash

sudo make -s -C ../U-Boot qemu_arm64_defconfig
sudo make -C ../U-Boot CROSS_COMPILE=aarch64-linux-gnu-
cp ../U-Boot/u-boot.bin ./u-boot.bin