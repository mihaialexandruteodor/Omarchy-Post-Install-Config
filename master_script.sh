#!/bin/sh

echo "Starting config for $(whoami)"

# Makes all .sh files in the scripts folder executable
chmod +x ./scripts/*.sh

# overwrite alacritty config
mv -f ./scripts/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"

# install  YAZI & deps
sudo pacman -S yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

./scripts/installer.sh
./scripts/plex-desktop.sh
./scripts/uninstaller.sh
./scripts/remapper.sh
./scripts/installer_eslint.sh

rm -rf ~/.config/waybar

./scripts/caelestia-shell.sh

# Run Omarchy Steam installer using current user's home directory
"$HOME/.local/share/omarchy/bin/omarchy-install-steam"
#./scripts/themes.sh

omarchy-theme-set everforest

./scripts/vmware-install.sh
#./scripts/wallpapers.sh
./scripts/echo-into-configs.sh

# omarchy cleaner
curl -fsSL https://raw.githubusercontent.com/maxart/omarchy-cleaner/main/omarchy-cleaner.sh | bash

sudo pacman -Rns fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt

reboot
