#!/bin/bash
# Flat repo: ui.sh in same folder
source "$(dirname "$0")/ui.sh"

echo "-----Mounting Partitions-----"

# Root
ROOT_PART=$(cat /tmp/enux-root)
mount "$ROOT_PART" /mnt

# EFI
EFI_PART=$(cat /tmp/enux-efi)
if [ -n "$EFI_PART" ]; then
    mkdir -p /mnt/boot/efi
    mount "$EFI_PART" /mnt/boot/efi
fi

# Swap
SWAP_PART=$(cat /tmp/enux-swap)
swapon "$SWAP_PART"

echo "Partitions mounted! Press ENTER to continue..."
read
