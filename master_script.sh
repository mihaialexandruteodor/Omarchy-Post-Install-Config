#!/bin/sh

echo "Starting config for $(whoami)"

# Makes all .sh files in the scripts folder executable
chmod +x ./scripts/*.sh

# overwrite alacritty config
mv -f ./scripts/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"

./scripts/installer.sh
./scripts/uninstaller.sh
./scripts/remapper.sh
./scripts/installer_eslint.sh
# Run Omarchy Steam installer using current user's home directory
"$HOME/.local/share/omarchy/bin/omarchy-install-steam"
./scripts/themes.sh
#./scripts/wallpapers.sh
