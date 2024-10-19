# Derekputer

## Derek OS
Run `chmod +x ./derek-os.sh && ./derek-os.sh` to install Derek OS, this will download, install and compile:

* Debian stable
  * Installed via debootstrap
* Armbian build
  * Used for some patches and files needed
* Armbian firmware
  * Used to install the firmware required for some drivers to work
* Linux
  * Linux Image, Modules and DTB's for Derek OS
* Trusted Firmware A
  * Creates the BL31 binary required for U-Boot to compile
* U-Boot
  * Bootloader for Derekputer

along with files and scripts for full automatic setup

## Partitioning
Install Derek OS then run `chmod +x ./partition.sh && ./partition.sh <disk name>` to partition Derek OS to disk (SD card), this will:

* Create a MBR label
* Create a ext4 partition starting at 1MB
* Write zeros 8KiB-1MB
* Flash U-Boot bootloader at 8KB
* Mount the partition at ./Mount
* Copy Derek OS to the partition
* Copy required files to the /boot directory of the partition

## Testing
After installing Derek OS you can go into the Test directory then run `chmod +x ./create-img.sh && ./create-img.sh` and `chmod +x ./qemu.sh && ./qemu.sh` to boot Derek OS under QEMU (hopefully)

## Other
* `clean.sh` will remove most directories and files created during downloading/compiling Derek OS
* `setup.sh` is run during the setup of Derek OS in a chroot environment
* `first-boot.sh` is run the first time Derek OS is booted
* `derek-os-compile.sh` compiles everything required
* `derek-os-download.sh` downloads everything required
* `derek-os-download.sh` sets up Derek OS
* `extra-commands.sh` runs in the chroot environment while setting up Derek OS
* `Test/qemu-dtb.sh` will dump the DTB used for QEMU
* `Test/u-boot.sh` will compile U-Boot for QEMU
* `fstab` is the fstab used
* `hostname` is the hostname used
* `services.txt` is the services that will be enabled and started
* `patches.txt` is the patches required for Derek OS to function
* `nmcli-args.txt` is the nmcli args run to setup networking
* `docker-compose.yml` is the Docker Compose for all the Docker containers
* `boot.cmd` is the commands run on the boot loader, it must be converted to `boot.scr` using `gen_boot_script.sh`
* `apt-packages.txt` is any extra packages you might want
* `Home` is where directories and files can be placed that will get copied over to the the home directory during install

## Notes
* You can copy stuff into the `Home` directory to copy things over such as Docker volumes
* Spams the fuck out of serial terminal with Wi-Fi warnings, ignore :)
* Drivers aren't all there, everything that is absolutely **needed** works (I think)
* The module `sprdbt_tty` is probably not loaded on boot meaning Bluetooth won't work, *should* work with `sudo modprobe sprdbt_tty && sudo systemctl start aw859a-bluetooth`