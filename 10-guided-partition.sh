#!/bin/bash
# Ensure flat repo: ui.sh in same folder
source "$(dirname "$0")/ui.sh"

echo "-----Guided Partitioning-----"

# List available disks
echo "Available disks:"
/usr/bin/lsblk -d -o NAME,SIZE
echo ""

# Ask for installation disk
read -p "Enter the disk to install ENux on (e.g., /dev/sda): " INSTALL_DISK

# Validate disk
if [ ! -b "$INSTALL_DISK" ]; then
    echo "Error: $INSTALL_DISK is not a valid block device."
    read -p "Press ENTER to exit."
    exit 1
fi

# Confirm before wiping
read -p "Warning: $INSTALL_DISK will be completely erased! Type YES to continue: " CONFIRM
if [ "$CONFIRM" != "YES" ]; then
    echo "Aborting installation."
    exit 1
fi

echo "Wiping $INSTALL_DISK..."
/usr/sbin/wipefs -a "$INSTALL_DISK"
/usr/sbin/parted -s "$INSTALL_DISK" mklabel gpt

# Detect UEFI
EFI_PART=""
if [ -d /sys/firmware/efi ]; then
    echo "UEFI detected. Creating 1GB EFI partition..."
    /usr/sbin/parted -s "$INSTALL_DISK" mkpart ESP fat32 1MiB 1025MiB
    /usr/sbin/parted -s "$INSTALL_DISK" set 1 esp on
    EFI_PART="${INSTALL_DISK}1"
fi

# Swap (10GB)
START_SWAP=1025
END_SWAP=$((START_SWAP + 10240))
/usr/sbin/parted -s "$INSTALL_DISK" mkpart primary linux-swap ${START_SWAP}MiB ${END_SWAP}MiB
SWAP_PART="${INSTALL_DISK}2"

# Root partition (rest of disk)
/usr/sbin/parted -s "$INSTALL_DISK" mkpart primary ext4 ${END_SWAP}MiB 100%
ROOT_PART="${INSTALL_DISK}3"

# Format partitions
[ -n "$EFI_PART" ] && /usr/sbin/mkfs.fat -F32 "$EFI_PART"
/usr/sbin/mkswap "$SWAP_PART"
/usr/sbin/mkfs.ext4 "$ROOT_PART"

# Mount partitions
/usr/sbin/mount "$ROOT_PART" /mnt
[ -n "$EFI_PART" ] && /usr/sbin/mkdir -p /mnt/boot/efi && /usr/sbin/mount "$EFI_PART" /mnt/boot/efi
/usr/sbin/swapon "$SWAP_PART"

# Save paths for later
echo "$ROOT_PART" > /tmp/enux-root
echo "$EFI_PART" > /tmp/enux-efi
echo "$SWAP_PART" > /tmp/enux-swap

echo "Partitioning complete!"
read -p "Press ENTER to continue..."
