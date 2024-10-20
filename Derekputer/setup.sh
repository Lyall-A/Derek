#!/bin/bash
# Runs in chroot environment

set -e

password="Derek1234*"
root_password="Root1234*"

if [ -f "/debootstrap/debootstrap" ]; then
    echo "Running second stage of debootstrap..."
    /debootstrap/debootstrap --second-stage
else
    echo "Debootstrap not found, assuming not needed"
fi

echo "Installing packages..."
apt install -y curl ca-certificates sudo network-manager systemd-timesyncd

if [[ -f "/Derek-OS-Temp/apt-packages.txt" && "$(cat /Derek-OS-Temp/apt-packages.txt)" ]]; then
    echo "Installing optional packages..."
    apt install -y $(cat /Derek-OS-Temp/apt-packages.txt)
fi

echo "Adding Docker to APT repositories..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

echo "Installing Docker..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Setting up users..."
/sbin/useradd -m -s /bin/bash -G sudo,docker -c "Derek" derek
echo "derek:$password" | /sbin/chpasswd
echo "root:$root_password" | /sbin/chpasswd

echo "Copying necessary files..."
mv /Derek-OS-Temp/Firmware/* /lib/firmware
mv /Derek-OS-Temp/aw859a-wifi.service /lib/systemd/system
mv /Derek-OS-Temp/hostname /etc
mv /Derek-OS-Temp/fstab /etc
mv /Derek-OS-Temp/first-boot.service /lib/systemd/system
mv /Derek-OS-Temp/docker-compose.yml /home/derek
mv /Derek-OS-Temp/first-boot.sh /home/derek
mv /Derek-OS-Temp/nmcli-args.txt /home/derek
mv /Derek-OS-Temp/services.txt /home/derek
chmod +x /home/derek/first-boot.sh

echo "Enabling first boot service..."
ln -s /lib/systemd/system/first-boot.service /lib/systemd/system/multi-user.target.wants/first-boot.service

echo "Setting up swap..."
fallocate -l 2G /swapfile
chmod 600 /swapfile
/sbin/mkswap /swapfile

if [[ -d "/Derek-OS-Temp/Home" && "$(ls -A /Derek-OS-Temp/Home)" ]]; then
    echo "Copying files to home..."
    mv /Derek-OS-Temp/Home/* /home/derek
fi

if [[ -f "/Derek-OS-Temp/extra-commands.sh" ]]; then
    echo "Running extra commands..."
    source /Derek-OS-Temp/extra-commands.sh
fi

echo "Making user 'derek' owner of home directory recursively..."
chown -R derek:derek /home/derek

echo "Removing temp directory..."
rm -r /Derek-OS-Temp

echo "Finished setup in chroot!"