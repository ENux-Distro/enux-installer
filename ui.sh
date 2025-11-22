#!/bin/bash

# Print a horizontal line
line() {
    printf "%*s\n" "$(tput cols)" "" | tr ' ' '-'
}

# Display a title for a module
title() {
    clear
    echo ""
    echo " ENux Installer"
    line
    echo " $1"
    line
}

# Simple menu function (optional)
menu() {
    local prompt="$1"
    shift
    local options=("$@")
    PS3="$prompt "
    select opt in "${options[@]}"; do
        if [[ -n "$opt" ]]; then
            echo "$opt"
            break
        fi
    done
}
