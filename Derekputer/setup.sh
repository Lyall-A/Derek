#!/bin/bash
# Runs in chroot environment

set -e

password=Derek1234*

echo "Running second stage of debootstrap..."
/debootstrap/debootstrap --second-stage

echo "Updating package information..."
apt-get update

echo "Installing packages..."
apt-get install -y sudo ca-certificates curl

echo "Installing Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Upgrading packages..."
apt-get upgrade -y

echo "Adding user"
/usr/sbin/useradd -m -s /bin/bash -G sudo -c "Derek" -p "$password" derek

#echo "Creating directories..."

echo "Copying necessary files..."
cp /mnt/docker-compose.yml /home/derek/docker-compose.yml
cp /mnt/first-boot.sh /home/derek/first-boot.sh
cp /mnt/first-boot.service /etc/systemd/system/first-boot.service
chmod +x /home/derek/first-boot.sh

echo "Enabling services..."
ln -s /lib/systemd/system/docker.service /etc/systemd/system/multi-user.target.wants/docker.service
ln -s /etc/systemd/system/first-boot.service /etc/systemd/system/multi-user.target.wants/first-boot.service

if [ -d "/mnt/files" ]; then
    echo "Copying files..."
    cp -r /mnt/Files/* /
fi