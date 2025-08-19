#!/bin/bash
# This script installs basic configuration for bspwm and related tools for Debian.

echo "Installing the packages..."
sudo apt update || { echo "Error: apt update failed. Exiting."; exit 1; }
sudo apt install -y bspwm sxhkd picom polybar rofi alacritty || { echo "Error: Package installation failed. Exiting."; exit 1; }

echo "Packages installed. Now configuring the window tiling manager..."

# Create configuration directories (using -p for idempotency, no sudo needed for user's home)
mkdir -p ~/.config/bspwm/
mkdir -p ~/.config/sxhkd/
mkdir -p ~/.config/polybar/
mkdir -p ~/.config/picom
mkdir -p ~/.config/rofi

# Copy configuration files (no sudo needed for user's home)
cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/
cp config.ini ~/.config/polybar/
cp picom.conf ~/.config/picom
cp toggle.sh ~/.config/polybar/
cp config.rasi ~/.config/rofi/

echo "Creating a basic .xinitrc file..."
# Create a basic .xinitrc if it doesn't exist
if [ ! -f ~/.xinitrc ]; then
    echo "sxhkd &" > ~/.xinitrc
    echo "picom &" >> ~/.xinitrc
    echo "exec bspwm" >> ~/.xinitrc
    echo "Created a basic ~/.xinitrc. You may need to customize it."
else
    echo "~/.xinitrc already exists. Skipping creation."
fi

echo "Configuration complete. Please reboot your session or system."
