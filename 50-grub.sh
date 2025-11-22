#!/bin/bash
source /lib/ui.sh

echo "-----Installing GRUB Bootloader-----"

# Detect which disk to install GRUB to
DISK=$(cat /tmp/enux-root | sed 's/[0-9]*$//') # strip partition number

echo "Installing GRUB to $DISK..."
arch-chroot /mnt grub-install "$DISK"
arch-chroot /mnt update-grub

echo "GRUB installation complete."
read -p "Press ENTER to continue..."
