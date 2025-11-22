#!/bin/bash
source "$(dirname "$0")/ui.sh"

echo "-----Installing ENux Scripts-----"
echo "Cloning ENux-goodies repository..."
read -p "Press ENTER to continue..."

# Ensure git is available
if ! command -v git &>/dev/null; then
    apt update
    apt install -y git
fi

# Mount virtual filesystems before chroot
mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run

# Run ENux phase0 inside chroot
chroot /mnt /bin/bash -c "
git clone https://github.com/ENux-Distro/ENux-goodies.git /root/ENux-goodies
cd /root/ENux-goodies
bash phase0.sh
"

echo "ENux installation phases finished."
read -p "Press ENTER to continue..."
