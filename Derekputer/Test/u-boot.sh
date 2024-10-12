#!/bin/bash

sudo make -s -C ../U-Boot qemu_arm64_defconfig
cp ../U-Boot/u-boot.bin ./u-boot.bin