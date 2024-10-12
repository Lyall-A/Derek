#!/bin/bash

sudo umount ./Derek-OS/mnt
sudo umount ./Derek-OS/proc
sudo umount ./Derek-OS/dev
sudo umount ./Derek-OS/sys
# sudo umount ./Mount/boot
sudo umount ./Mount
# sudo umount ./Test/Mount/boot
sudo umount ./Test/Mount
sudo rm -r ./Debian
sudo rm -r ./Linux
sudo rm -r ./ARM-Trusted-Firmware
sudo rm -r ./U-Boot
sudo rm -r ./Derek-OS
sudo rm -r ./Mount
sudo rm -r ./Test/Mount
sudo rm ./sun50i-h618-orangepi-zero3.dtb
sudo rm ./Image.gz
sudo rm ./BL31.bin
sudo rm ./u-boot-sunxi-with-spl.bin
sudo rm ./Test/derek-os.img
# sudo rm ./Test/boot.img
# sudo rm ./Test/root.img