#!/bin/bash
# Downloads everything needed for Derek OS

set -e

download() {
    name=$1
    dir=$2
    command=$3
    if [ -d "$dir" ]; then
        echo "$name already downloaded, removing..."
        sudo rm -r "$dir"
    fi
    echo "Downloading $name..."
    $command
}

download_git() {
    name=$1
    dir=$2
    repo=$3
    if [ -d "$dir" ]; then
        echo "$name already downloaded, attempting to update..."
        git -C "$dir" pull
    else
        echo "Downloading $name..."
        git clone --depth=1 $repo "$dir"
    fi
}

# Download Debian stable
# download "Derek OS (Debian stable)" "Debian" "sudo debootstrap --foreign --arch=arm64 stable Debian http://deb.debian.org/debian"

# Download Armbian
download "Armbian" "Armbian.img.xz" "wget https://dl.armbian.com/orangepizero3/Bookworm_current_minimal -O ./Armbian.img.xz"
if [ -f "./Armbian.img" ]; then sudo rm ./Armbian.img; fi
sudo xz -d ./Armbian.img.xz

# Download Linux source
# download_git "Linux" "Linux" "--branch linux-6.11.y https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

# Download Trusted Firmware-A source
# download_git "Trusted Firmware-A" "Trusted-Firmware-A" "https://review.trustedfirmware.org/TF-A/trusted-firmware-a.git"

# Download U-Boot source
# download_git "U-Boot" "U-Boot" "https://source.denx.de/u-boot/u-boot.git"

# echo "Downloading patches from Armbian..."
# while read -r patch; do
#     wget -q -P ./Patches "https://raw.githubusercontent.com/armbian/build/main/patch$patch"
# done < ./patches.txt