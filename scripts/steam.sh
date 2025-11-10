#!/bin/sh

echo "Starting Steam installation for $(whoami)..."

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Enable multilib if not enabled
if ! grep -q "\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
    sudo sed -i '/#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf
    sudo pacman -Sy --noconfirm
else
    echo "Multilib already enabled."
fi

# Install Steam
echo "Installing Steam..."
sudo pacman -S --noconfirm steam

# Optional: Ask to install native runtime
echo "Do you want to install steam-native-runtime for better performance? (y/N): "
read choice
case "$choice" in
    [Yy]*) sudo pacman -S --noconfirm steam-native-runtime ;;
    *) echo "Skipping native runtime installation." ;;
esac

# Detect GPU and install drivers
echo "Detecting GPU..."
if lspci | grep -i nvidia >/dev/null 2>&1; then
    echo "NVIDIA GPU detected."
    sudo pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils
elif lspci | grep -i amd >/dev/null 2>&1; then
    echo "AMD GPU detected."
    sudo pacman -S --noconfirm mesa lib32-mesa
elif lspci | grep -i intel >/dev/null 2>&1; then
    echo "Intel GPU detected."
    sudo pacman -S --noconfirm mesa lib32-mesa
else
    echo "No supported GPU detected, skipping driver installation."
fi

echo "Steam installation finished. You can launch it with 'steam'."
