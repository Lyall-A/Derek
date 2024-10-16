#!/bin/bash
# Partitions a disk for Derek OS

set -e

if [ -z "$1" ]; then
    echo "No disk has been chosen!"
    exit 1
fi
disk="/dev/$1"

echo "Starting in 5 seconds..."
sleep 5

echo "Unmounting $disk..."
sudo umount ${disk}1 || true
# sudo umount "${disk}2" || true

echo "Partitioning $disk..."
sudo parted $disk --script mklabel msdos
# sudo parted $disk --script mkpart primary fat32 1MiB 129MiB
# sudo parted $disk --script mkpart primary ext4 129MiB 100%
sudo parted $disk --script mkpart primary ext4 1MiB 100%

echo "Formatting partitions..."
sudo mkfs.ext4 -F ${disk}1
# sudo mkfs.vfat -F 32 ${disk}1
# sudo mkfs.ext4 -F ${disk}2

echo "Flashing U-Boot with SPL..."
sudo dd if=/dev/zero of=$disk bs=1024 count=1023 seek=1
sudo dd if=./u-boot-sunxi-with-spl.bin of=$disk bs=1024 seek=8
# sudo dd if=./sunxi-spl.bin of=$disk bs=1024 seek=8
# sudo dd if=./u-boot.itb of=$disk bs=1024 seek=8

echo "Mounting $disk..."
sudo mount --mkdir ${disk}1 ./Mount
# sudo mount --mkdir ${disk}2 ./Mount
# sudo mount --mkdir ${disk}1 ./Mount/boot

echo "Copying Derek OS to root..."
sudo cp -r ./Derek-OS/* ./Mount

echo "Copying files to boot..."
sudo mkdir -p ./Mount/boot
sudo cp ./boot.scr ./Mount/boot
sudo cp ./Image ./Mount/boot
sudo cp ./sun50i-h618-orangepi-zero3.dtb ./Mount/boot
sudo cp ./u-boot-sunxi-with-spl.bin ./Mount/boot

echo "Unmounting $disk..."
sudo umount ${disk}1
# sudo umount ${disk}2

echo "Done!"