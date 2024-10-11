#!/bin/bash

sudo umount ./Derek-OS/mnt
sudo umount ./Derek-OS/dev
sudo umount ./Derek-OS/proc
sudo umount ./Derek-OS/sys
sudo umount ./Derek-OS/run
sudo umount ./Mount/boot
sudo umount ./Mount
sudo rm -rf ./Debian
sudo rm -rf ./Linux
sudo rm -rf ./ARM-Trusted-Firmware
sudo rm -rf ./U-Boot
sudo rm -rf ./Derek-OS
sudo rm -rf ./Mount
sudo rm ./sun50i-h618-orangepi-zero3.dtb
sudo rm ./Image
sudo rm ./BL31.bin
sudo rm ./u-boot-sunxi-with-spl.bin