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
download "Derek OS (Debian stable)" "Debian" "sudo debootstrap --foreign --arch=arm64 stable Debian http://deb.debian.org/debian"

# Download Linux source
download_git "Linux" "Linux" "--branch linux-6.11.y https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"

# Download Armbian build source
download_git "Armbian build" "Armbian/Build" "https://github.com/armbian/build.git"

# Download Armbian Linux firmware source
download_git "Armbian Linux firmware" "Armbian/Firmware" "https://github.com/armbian/firmware.git"

# Download Trusted Firmware-A source
download_git "Trusted Firmware-A" "Trusted-Firmware-A" "https://review.trustedfirmware.org/TF-A/trusted-firmware-a.git"

# Download U-Boot source
download_git "U-Boot" "U-Boot" "https://source.denx.de/u-boot/u-boot.git"

cd Linux
echo "Applying Linux patches..."
while read -r patch; do
    echo "Applying '$patch'..."
    patch --batch -p1 -N --input="../$patch" --quiet --reject-file=/dev/null
done < ../patches.txt

echo "Adding uwe5622 to wireless Makefile..."
echo "obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/" >> ./drivers/net/wireless/Makefile
cd ..