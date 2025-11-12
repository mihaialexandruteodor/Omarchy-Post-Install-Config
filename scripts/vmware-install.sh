#!/bin/sh

echo "Installing VMWare..."

# Exit immediately if a command fails
set -e

echo "Installing required packages via yay..."
yay -S fuse2 gtkmm linux-headers pcsclite libcanberra

echo "Installing ncurses5-compat-libs (if not already installed)..."
yay -S --noconfirm --needed ncurses5-compat-libs

echo "Installing VMware Workstation (if not already installed)..."
yay -S --noconfirm --needed vmware-workstation

echo "Enabling VMware services..."
sudo systemctl enable vmware-networks.service vmware-usbarbitrator.service vmware-hostd.service

echo "Starting VMware services..."
sudo systemctl start vmware-networks.service vmware-usbarbitrator.service vmware-hostd.service

echo "All done!"
