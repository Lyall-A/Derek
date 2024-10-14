# Derekputer

## Derek OS
Run `chmod +x ./derek-os.sh && ./derek-os.sh` to install Derek OS, this will download and install/compile:

* Debian stable
  * Installed via debootstrap
* Linux
  * Linux Image and DTB's for Derek OS
* ARM Trusted Firmware
  * Creates the BL31 binary required for U-Boot to compile
* U-Boot
  * Bootloader for Derekputer

along with files and scripts for full automatic setup

## Partitioning
Install Derek OS then run `chmod +x ./partition.sh && ./partition.sh <disk name>` to partition Derek OS to disk (SD card), this will:

* Create a MBR label
* Create a 16MB FAT32 partition (boot) starting at 1MB
* Create a ext4 partition (root) starting at 17MB filling the rest of the disk
* Write zeros 8KiB-1MB
* Flash U-Boot bootloader at 8KB
* Mount the root partition at ./Mount
* Mount the boot partition at ./Mount/boot
* Copy Derek OS to the root partition
* Copy required files to the boot partiion

## Testing
After installing Derek OS you can go into the Test directory then run `chmod +x ./create-img.sh && ./create-img.sh` and `chmod +x ./qemu.sh && ./qemu.sh` to boot Derek OS under QEMU (hopefully)

## Other
* `clean.sh` will remove most directories and files created during downloading/compiling Derek OS
* `setup.sh` is run during the setup of Derek OS in a chroot environment
* `first-boot.sh` is run the first time Derek OS is booted
* `Test/qemu-dtb.sh` will dump the DTB used for QEMU
* `Test/u-boot.sh` will compile U-Boot for QEMU
* `Copy` is where directories and files can be placed that will get copied over to the the home directory on Derek OS during install