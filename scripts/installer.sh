#!/bin/sh

echo "Starting to install desired programs..."

# pacman installs first
sudo pacman -S mpv

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CSV_FILE="$SCRIPT_DIR/packages_install.csv"

if [ ! -f "$CSV_FILE" ]; then
  echo "Error: CSV file not found at $CSV_FILE"
  exit 1
fi

echo ">>> Updating package database..."
yay -Syu --noconfirm

while IFS= read -r line || [ -n "$line" ]; do
  line=$(echo "$line" | tr ',' ' ' | xargs)

  for pkg in $line; do
    if [ -z "$pkg" ] || echo "$pkg" | grep -qE '^\s*#'; then
      continue
    fi

    echo ">>> Installing $pkg..."
    yay -S --noconfirm --needed "$pkg"
  done
done < "$CSV_FILE"

# get wallpaper files
mkdir -p ~/Documents/wallpapers
cd ~/Documents/wallpapers
wget -r -np -nH --cut-dirs=4 -R "index.html*" https://github.com/mihaialexandruteodor/wallpaper-stash/raw/main/live/


# init live wallpaper on startup - this adds to hyprland config if it doesn't exist yet
grep -qxF "exec-once = mpvpaper -o \"no-audio loop\" \"\$(hyprctl monitors -j | jq -r '.[0].name')\" \"$HOME/Documents/wallpapers/moonlight-shadow-of-ryuk.3840x2160.mp4\"" ~/.config/hypr/hyprland.conf || \
echo "exec-once = mpvpaper -o \"no-audio loop\" \"\$(hyprctl monitors -j | jq -r '.[0].name')\" \"$HOME/Documents/wallpapers/moonlight-shadow-of-ryuk.3840x2160.mp4\"" >> ~/.config/hypr/hyprland.conf


echo "✅ Installation complete!"
