#!/bin/bash
source ../lib/ui.sh

title "Mounting Partitions"

ROOT_PART=$(cat /tmp/enux-root)
mount "$ROOT_PART" /mnt

EFI_PART=$(cat /tmp/enux-efi)
if [ -n "$EFI_PART" ]; then
    mkdir -p /mnt/boot/efi
    mount "$EFI_PART" /mnt/boot/efi
fi

SWAP_PART=$(cat /tmp/enux-swap)
swapon "$SWAP_PART"

echo "Partitions mounted! Press ENTER to continue..."
read
