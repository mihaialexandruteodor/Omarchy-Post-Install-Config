#!/bin/sh

echo "Starting config for $(whoami)"

# Makes all .sh files in the scripts folder executable
chmod +x ./scripts/*.sh

./scripts/installer.sh
./scripts/uninstaller.sh
./scripts/remapper.sh
./scripts/installer_eslint.sh
./scripts/steam.sh
./scripts/themes.sh
./scripts/wallpapers.sh
