#!/bin/bash
# Sets up Derek OS, assuming the Derek-OS directory is ready

set -e

sudo mkdir -p ./Derek-OS/Derek-OS-Temp

echo "Copying necessary files to Derek OS..."
sudo cp -r ./Copy ./Derek-OS/Derek-OS-Temp
sudo cp ./nmcli-args.txt ./Derek-OS/Derek-OS-Temp
sudo cp ./services.txt ./Derek-OS/Derek-OS-Temp
sudo cp ./apt-packages.txt ./Derek-OS/Derek-OS-Temp
sudo cp ./derek-psu-config.json ./Derek-OS/Derek-OS-Temp
sudo cp ./derek-cam-config.json ./Derek-OS/Derek-OS-Temp
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