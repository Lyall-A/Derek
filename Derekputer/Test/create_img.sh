#!/bin/bash

sudo umount ./Mount/boot
sudo umount ./Mount
sudo rm -f ./root.img
sudo rm -f ./boot.img

set -e

qemu-img create -f raw ./root.img 5G
sudo mkfs.ext4 ./root.img
sudo mount --mkdir ./root.img ./Mount
sudo cp -r ../Derek-OS/* ./Mount

qemu-img create -f raw ./boot.img 128M
sudo mkfs.vfat -F 32 ./boot.img
sudo mount --mkdir ./boot.img ./Mount/boot
sudo cp ../Image ./Mount/boot
sudo cp ./qemu.dtb ./Mount/boot
sudo cp ./u-boot.bin ./Mount/boot/u-boot.bin
sudo cp ../sun50i-h618-orangepi-zero3.dtb ./Mount/boot
sudo cp ../u-boot-sunxi-with-spl.bin ./Mount/boot