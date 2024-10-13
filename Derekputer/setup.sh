#!/bin/bash
# Runs in chroot environment

set -e

password="Derek1234*"
root_password="Root1234*"

echo "Installing packages..."
apt install -y curl ca-certificates sudo network-manager

if [[ -d "/Derek-OS-Temp/apt-packages.txt" && "$(cat /Derek-OS-Temp/apt-packages.txt)" ]]; then
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
/usr/sbin/useradd -m -s /bin/bash -G sudo -c "Derek" derek
echo "derek:$password" | /usr/sbin/chpasswd
echo "root:$root_password" | /usr/sbin/chpasswd

echo "Fixing sudo permissions..."
chown root:root /usr/bin/sudo
chmod 4755 /usr/bin/sudo

#echo "Creating directories..."

echo "Copying necessary files..."
mv /Derek-OS-Temp/hostname /etc/hostname
mv /Derek-OS-Temp/fstab /etc/fstab
mv /Derek-OS-Temp/docker-compose.yml /home/derek/docker-compose.yml
mv /Derek-OS-Temp/first-boot.sh /home/derek/first-boot.sh
mv /Derek-OS-Temp/first-boot.service /etc/systemd/system/first-boot.service
chmod +x /home/derek/first-boot.sh

echo "Enabling services..."
if [ ! -f "/etc/systemd/system/multi-user.target.wants/NetworkManager.service" ]; then ln -s /lib/systemd/system/NetworkManager.service /etc/systemd/system/multi-user.target.wants/NetworkManager.service; fi
if [ ! -f "/etc/systemd/system/multi-user.target.wants/docker.service" ]; then ln -s /lib/systemd/system/docker.service /etc/systemd/system/multi-user.target.wants/docker.service; fi
if [ ! -f "/etc/systemd/system/multi-user.target.wants/first-boot.service" ]; then ln -s /etc/systemd/system/first-boot.service /etc/systemd/system/multi-user.target.wants/first-boot.service; fi

if [[ -d "/Derek-OS-Temp/Copy" && "$(ls -A /Derek-OS-Temp/Copy)" ]]; then
    echo "Copying files..."
    mv /Derek-OS-Temp/Copy/* /home/derek
fi

echo "Setting up swap..."
fallocate -l 1G /swapfile
chmod 600 /swapfile
/usr/sbin/mkswap /swapfile

echo "Removing temp directory..."
rm -r /Derek-OS-Temp

echo "Done!"