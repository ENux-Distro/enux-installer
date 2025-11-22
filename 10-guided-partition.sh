#!/bin/bash
source /lib/ui.sh

title "Guided Partitioning"

echo "Available disks:"
lsblk -d -o NAME,SIZE
echo ""
read -p "Enter the disk to install ENux on (e.g. /dev/sda): " INSTALL_DISK

# Check if disk exists
if [ ! -b "$INSTALL_DISK" ]; then
    echo "Error: $INSTALL_DISK is not a block device."
    read -p "Press ENTER to exit."
    exit 1
fi

# Wipe the disk
echo "Wiping $INSTALL_DISK..."
wipefs -a "$INSTALL_DISK"
parted -s "$INSTALL_DISK" mklabel gpt

# Detect UEFI
EFI_PART=""
if [ -d /sys/firmware/efi ]; then
    echo "UEFI detected. Creating 1GB EFI partition..."
    parted -s "$INSTALL_DISK" mkpart ESP fat32 1MiB 1025MiB
    parted -s "$INSTALL_DISK" set 1 esp on
    EFI_PART="${INSTALL_DISK}1"
fi

# Swap (10GB)
START_SWAP=1025
END_SWAP=$((START_SWAP + 10240))
parted -s "$INSTALL_DISK" mkpart primary linux-swap ${START_SWAP}MiB ${END_SWAP}MiB
SWAP_PART="${INSTALL_DISK}2"

# Root partition (rest of disk)
ROOT_START=$((END_SWAP))
parted -s "$INSTALL_DISK" mkpart primary ext4 ${ROOT_START}MiB 100%
ROOT_PART="${INSTALL_DISK}3"

# Format partitions
[ "$EFI_PART" != "" ] && mkfs.fat -F32 "$EFI_PART"
mkswap "$SWAP_PART"
mkfs.ext4 "$ROOT_PART"

# Mount partitions
mount "$ROOT_PART" /mnt
[ "$EFI_PART" != "" ] && mkdir -p /mnt/boot/efi && mount "$EFI_PART" /mnt/boot/efi
swapon "$SWAP_PART"

# Save for later
echo "$ROOT_PART" > /tmp/enux-root
echo "$EFI_PART" > /tmp/enux-efi
echo "$SWAP_PART" > /tmp/enux-swap

echo "Partitioning complete! Press ENTER to continue..."
read
