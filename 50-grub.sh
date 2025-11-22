#!/bin/bash
source "$(dirname "$0")/ui.sh"

echo "-----Installing GRUB Bootloader-----"

# Detect which disk to install GRUB to (strip partition number from root)
DISK=$(cat /tmp/enux-root | sed 's/[0-9]*$//')
echo "Installing GRUB to $DISK..."

# Ensure virtual filesystems are mounted for chroot
mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run

# Install GRUB (handles BIOS/UEFI if grub-pc/efi is installed)
chroot /mnt /bin/bash -c "
apt update
apt install -y grub-pc grub-efi
grub-install $DISK
update-grub
"

echo "GRUB installation complete."
read -p "Press ENTER to continue..."

