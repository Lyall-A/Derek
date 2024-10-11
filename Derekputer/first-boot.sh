#!/bin/bash
# Runs on first boot

if [ -f "/home/derek/.first-boot" ]; then
    echo "Not first boot!"
    systemctl disable first-boot.service
    exit 1
fi

echo "Setting up containers..."
docker compose -f /home/derek/docker-compose.yml up

echo "First boot finished"
systemctl disable first-boot.service
touch /home/derek/.first-boot