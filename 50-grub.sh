#!/bin/bash
source /lib/ui.sh

echo "-----Installing GRUB Bootloader-----"

# Detect which disk to install GRUB to
DISK=$(cat /tmp/enux-root | sed 's/[0-9]*$//') # strip partition number
echo "Installing GRUB to $DISK..."

# Make sure virtual filesystems are mounted before chroot
mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run

# Install GRUB
chroot /mnt /bin/bash -c "grub-install $DISK && update-grub"


echo "GRUB installation complete."
read -p "Press ENTER to continue..."
