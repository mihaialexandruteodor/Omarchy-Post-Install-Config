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
./scripts/vmware-install.sh
#./scripts/wallpapers.sh

# add clipse to hyprland conf
echo -e "\nexec-once = clipse -listen # run listener on startup\nwindowrulev2 = float,class:(clipse) # ensure you have a floating window class set if you want this behavior\nwindowrulev2 = size 622 652,class:(clipse) # set the size of the window as necessary\nbind = SUPER, V, exec, <terminal name> --class clipse -e 'clipse' # Example: bind = SUPER, V, exec, alacritty --class clipse -e 'clipse'" >> ~/.config/hypr/hyprland.conf

# omarchy cleaner
curl -fsSL https://raw.githubusercontent.com/maxart/omarchy-cleaner/main/omarchy-cleaner.sh | bash
