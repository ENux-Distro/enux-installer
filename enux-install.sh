#!/bin/bash
set -e

BASE_DIR="$(dirname "$0")"

# Load shared libraries (flat structure)
source "$BASE_DIR/ui.sh"
source "$BASE_DIR/utils.sh"

title "Welcome to ENux Installer"
read -p "Press ENTER to start..."

# Run all module scripts in order (flat structure)
for step in 00-welcome.sh 10-guided-partition.sh 20-mount.sh 30-install-base.sh 40-install-enux.sh 50-grub.sh 99-finish.sh; do
    bash "$BASE_DIR/$step"
done

title "Installation complete!"
echo "You can now reboot your system."
