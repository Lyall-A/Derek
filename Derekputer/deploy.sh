#!/bin/bash

if [ -z "$(command -v debootstrap)" ]; then
    echo "debootstrap is not installed!"
    exit 1
fi

if [ -z "$(command -v qemu-aarch64-static)" ]; then
    echo "qemu-aarch64-static is not installed!"
    exit 1
fi

echo "Installing Debian stable..."
# sudo debootstrap --foreign --arch=arm64 stable Derek-OS

echo "Adding qemu-aarch64-static..."
sudo cp "$(command -v qemu-aarch64-static)" Derek-OS/usr/bin

echo "Mounting..."
sudo mount --bind /dev Derek-OS/dev
sudo mount --bind /proc Derek-OS/proc
sudo mount --bind /sys Derek-OS/sys

echo "Entering chroot environment..."
sudo chroot Derek-OS /usr/bin/qemu-aarch64-static /bin/bash -c "
    echo todo
"

echo "Unmounting..."
sudo umount Derek-OS/dev
sudo umount Derek-OS/proc
sudo umount Derek-OS/sys
