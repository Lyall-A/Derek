#!/bin/bash
# Runs on first boot

set -e

if [ -f "/home/derek/.first-boot" ]; then
    echo "Not first boot!"
    systemctl disable first-boot.service
    exit 1
fi

echo "Setting up containers..."
docker compose -f /home/derek/docker-compose.yml up

touch /home/derek/.first-boot
systemctl disable first-boot.service
echo "First boot complete"