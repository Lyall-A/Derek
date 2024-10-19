#!/bin/bash
# Runs on first boot

set -e

if [ -f "/home/derek/.first-boot" ]; then
    echo "Not first boot!"
    systemctl disable first-boot
    exit 1
fi

echo "Enabling services..."
systemctl enable aw859a-wifi
systemctl enable NetworkManager
systemctl enable docker
while read -r service; do
    systemctl enable $service || true
done < /home/derek/services.txt

echo "Starting services..."
systemctl start aw859a-wifi
systemctl start NetworkManager
systemctl start docker
while read -r service; do
    systemctl start $service || true
done < /home/derek/services.txt

echo "Setting up network..."
nmcli $(cat /home/derek/nmcli-args.txt)

echo "Setting up containers..."
docker compose -f /home/derek/docker-compose.yml up -d

touch /home/derek/.first-boot
systemctl disable first-boot
echo "First boot complete!"