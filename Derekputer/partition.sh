#!/bin/bash

if [ -z "$1" ]; then
    echo "No disk has been chosen!"
    exit 1
fi

disk="/dev/$1"

echo "Starting in 5 seconds..."
sleep 5

echo "Unmounting ${disk}..."
sudo umount "${disk}1"
sudo umount "${disk}2"

echo "Partitioning ${disk}..."
sudo parted "$disk" --script mklabel msdos
sudo parted "$disk" --script mkpart primary fat32 0% 128MB
sudo parted "$disk" --script mkpart primary ext4 128MB 100%

echo "Formatting partitions..."
sudo mkfs.vfat -I -F 32 "${disk}1"
sudo mkfs.ext4 -F "${disk}2"

echo "Mounting ${disk}..."
sudo mkdir ./Mount
sudo mount "${disk}2" ./Mount
sudo mkdir ./Mount/boot
sudo mount "${disk}1" ./Mount/boot

echo "Copying Derek OS..."
sudo cp -r ./Derek-OS/* ./Mount

echo "Flashing U-Boot and SPL..."
sudo dd if=U-Boot-with-SPL.bin of="$disk" bs=8k seek=1