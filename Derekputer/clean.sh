#!/bin/bash
# Cleans up

sudo umount -l ./Derek-OS/proc
sudo umount -l ./Derek-OS/dev
sudo umount -l ./Derek-OS/sys
sudo umount ./Mount
sudo umount ./Test/Mount
sudo rm -r ./Armbian
sudo rm -r ./Debian
sudo rm -r ./Linux
sudo rm -r ./Trusted-Firmware-A
sudo rm -r ./U-Boot
sudo rm -r ./Derek-OS
sudo rm -r ./Mount
sudo rm -r ./Test/Mount
sudo rm ./Test/derek-os.img