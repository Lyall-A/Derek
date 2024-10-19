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

echo "Partitioning $disk..."
sudo parted $disk --script mklabel msdos
sudo parted $disk --script mkpart primary ext4 1MiB 100%

echo "Formatting partitions..."
sudo mkfs.ext4 -F ${disk}1
sudo e2label ${disk}1 Derek-OS

echo "Flashing U-Boot with SPL..."
sudo dd if=/dev/zero of=$disk bs=1024 count=1023 seek=1
sudo dd if=./U-Boot/u-boot-sunxi-with-spl.bin of=$disk bs=1024 seek=8

echo "Mounting $disk..."
sudo mount --mkdir ${disk}1 ./Mount

echo "Copying Derek OS to root..."
sudo cp -a ./Derek-OS/* ./Mount

echo "Copying files to boot..."
sudo mkdir -p ./Mount/boot
sudo mkdir -p ./Mount/boot/dtb/allwinner
sudo cp ./boot.scr ./Mount/boot
sudo cp ./Linux/arch/arm64/boot/Image ./Mount/boot
sudo cp -r ./Linux/arch/arm64/boot/dts/allwinner/*.dtb ./Mount/boot/dtb/allwinner

echo "Ejecting $disk..."
until sudo eject $disk; do
    echo "Failed to eject $disk, retrying in 1 second..."
    sleep 1
done

echo "Done!"