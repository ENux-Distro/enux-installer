#!/bin/bash
set -e

BASE_DIR="$(dirname "$0")"

# Load shared libraries
source "$BASE_DIR/lib/ui.sh"
source "$BASE_DIR/lib/utils.sh"

title "Welcome to ENux Installer"

read -p "Press ENTER to start..."

# Run all module scripts in order
for step in "$BASE_DIR"/modules/*.sh; do
    bash "$step"
done

title "Installation complete!"
echo "You can now reboot your system."
