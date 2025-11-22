#!/bin/bash
source ../lib/ui.sh

title "Installing ENux Scripts"

echo "Cloning ENux‑goodies repository..."
read -p "Press ENTER to continue..."

# Ensure git is available
if ! command -v git &>/dev/null; then
    apt update
    apt install -y git
fi

# Clone the repo into target system
arch-chroot /mnt bash -c "
git clone https://github.com/ENux‑Distro/ENux‑goodies.git /root/ENux‑goodies
cd /root/ENux‑goodies
bash phase0.sh
"

echo "ENux installation phases finished."
read -p "Press ENTER to continue..."
