#!/bin/bash
# Cleans up

sudo umount -l ./Derek-OS/proc
sudo umount -l ./Derek-OS/dev
sudo umount -l ./Derek-OS/sys
# sudo umount ./Mount/boot
sudo umount ./Mount
sudo umount ./Test/Mount
# sudo umount ./Test/Mount/boot
sudo rm -r ./Debian
sudo rm -r ./Linux
sudo rm -r ./ARM-Trusted-Firmware
sudo rm -r ./U-Boot
sudo rm -r ./Derek-OS
sudo rm -r ./Mount
sudo rm -r ./Test/Mount
sudo rm ./Test/derek-os.img