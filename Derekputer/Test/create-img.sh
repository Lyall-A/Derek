#!/bin/bash

set -e

# sudo umount ./Mount/boot || true
sudo umount ./Mount || true
sudo rm ./derek-os.img || true
# sudo rm ./root.img || true
# sudo rm ./boot.img || true

qemu-img create -f raw ./derek-os.img 5G
sudo mkfs.ext4 ./derek-os.img
sudo mount --mkdir ./derek-os.img ./Mount

# qemu-img create -f raw ./root.img 5G
# sudo mkfs.ext4 ./root.img
# sudo mount --mkdir ./root.img ./Mount

# qemu-img create -f raw ./boot.img 128M
# sudo mkfs.vfat -F 32 ./boot.img
# sudo mount --mkdir ./boot.img ./Mount/boot

sudo cp -r ../Derek-OS/* ./Mount

sudo cp ../boot.scr ./Mount/boot
sudo cp ../Image ./Mount/boot
sudo cp ./qemu.dtb ./Mount/boot
sudo cp ./u-boot.bin ./Mount/boot

# sudo umount ./Mount/boot
sudo umount ./Mount