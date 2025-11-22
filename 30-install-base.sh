#!/bin/bash
source /lib/ui.sh

echo "-----Installing Base System-----"

echo "Installing minimal Debian system to /mnt..."
read -p "Press ENTER to continue..."

# Install debootstrap if not present
if ! command -v debootstrap &>/dev/null; then
    echo "debootstrap not found, installing..."
    apt update
    apt install -y debootstrap
fi

# Run debootstrap
debootstrap --arch amd64 stable /mnt http://deb.debian.org/debian/

echo "Base system installed."
read -p "Press ENTER to continue..."
