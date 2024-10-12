#!/bin/bash
# Runs on first boot

set -e

if [ -f "/home/derek/.first-boot" ]; then
    echo "Not first boot!"
    systemctl disable first-boot.service
    exit 1
fi

echo "Enabling services..."
systemctl enable NetworkManager
systemctl enable docker

echo "Starting services..."
systemctl start NetworkManager
systemctl start docker

echo "Setting up network..."
# todo: nmcli command

echo "Setting up containers..."
docker compose -f /home/derek/docker-compose.yml up

touch /home/derek/.first-boot
systemctl disable first-boot.service
echo "First boot complete"