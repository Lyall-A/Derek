#!/bin/bash
# Sets up Derek OS, assuming the Derek-OS directory is ready

set -e

if [ -d "./Derek-OS" ]; then
    echo "Derek OS already exists, deleting it and continuing in 5 seconds..."
    sleep 5
    # May break your computer requiring a force reset :P
    sudo umount ./Derek-OS/proc || true
    sudo umount ./Derek-OS/dev || true
    sudo umount ./Derek-OS/sys || true
    sudo rm -r ./Derek-OS
fi

sudo mkdir -p ./Derek-OS

echo "Copying Debian files to Derek OS..."
sudo cp -r ./Debian/* ./Derek-OS

echo "Installing Linux Modules..."
sudo make -C ./Linux CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=../Derek-OS

sudo mkdir -p ./Derek-OS/Derek-OS-Temp

echo "Copying necessary files to Derek OS..."
sudo cp -r ./Home ./Derek-OS/Derek-OS-Temp
sudo cp -r ./Armbian/Firmware ./Derek-OS/Derek-OS-Temp
sudo cp ./Armbian/Build/packages/bsp/sunxi/aw859a-wifi.service ./Derek-OS/Derek-OS-Temp
sudo cp ./Armbian/Build/packages/bsp/sunxi/aw859a-bluetooth.service ./Derek-OS/Derek-OS-Temp
sudo cp ./Armbian/Build/packages/blobs/bt/hciattach/hciattach_opi_arm64 ./Derek-OS/Derek-OS-Temp
sudo cp ./nmcli-args.txt ./Derek-OS/Derek-OS-Temp
sudo cp ./services.txt ./Derek-OS/Derek-OS-Temp
sudo cp ./apt-packages.txt ./Derek-OS/Derek-OS-Temp
sudo cp ./extra-commands.sh ./Derek-OS/Derek-OS-Temp
sudo cp ./setup.sh ./Derek-OS/Derek-OS-Temp
sudo cp ./hostname ./Derek-OS/Derek-OS-Temp
sudo cp ./fstab ./Derek-OS/Derek-OS-Temp
sudo cp ./docker-compose.yml ./Derek-OS/Derek-OS-Temp
sudo cp ./first-boot.sh ./Derek-OS/Derek-OS-Temp
sudo cp ./first-boot.service ./Derek-OS/Derek-OS-Temp

echo "Starting binfmt..."
sudo systemctl start systemd-binfmt.service

echo "Mounting virtual directories..."
sudo mount --bind /proc ./Derek-OS/proc
sudo mount --bind /dev ./Derek-OS/dev
sudo mount --bind /sys ./Derek-OS/sys

echo "Running setup script in chroot..."
sudo chmod +x ./Derek-OS/Derek-OS-Temp/setup.sh
sudo chroot ./Derek-OS /Derek-OS-Temp/setup.sh

echo "Unmounting virtual directories..."
sudo umount -l ./Derek-OS/proc || true
sudo umount -l ./Derek-OS/dev || true
sudo umount -l ./Derek-OS/sys || true