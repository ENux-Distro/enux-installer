#!/bin/bash

# Check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Pause script until user presses Enter
pause() {
    read -p "Press ENTER to continue..."
}

