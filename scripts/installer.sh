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

#!/bin/bash

# 1️ Create wallpapers folder and download GitHub wallpapers
mkdir -p ~/Documents/wallpapers/live && \
git clone --depth 1 https://github.com/mihaialexandruteodor/wallpaper-stash.git /tmp/wallpaper-stash && \
cp /tmp/wallpaper-stash/live/* ~/Documents/wallpapers/live/ && \
rm -rf /tmp/wallpaper-stash

# 2️ Create the Hyprland startup script
mkdir -p ~/.config/hypr/scripts && \
cat > ~/.config/hypr/scripts/start-live-wallpaper.sh << 'EOF'
#!/bin/bash
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
WALLPAPER=$(find "$HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" | shuf -n1)
mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" &
EOF
chmod +x ~/.config/hypr/scripts/start-live-wallpaper.sh

# 3️ Add it to hyprland.conf if not already there
grep -qxF 'exec-once = ~/.config/hypr/scripts/start-live-wallpaper.sh' ~/.config/hypr/hyprland.conf || \
echo 'exec-once = ~/.config/hypr/scripts/start-live-wallpaper.sh' >> ~/.config/hypr/hyprland.conf

# 4️ Immediately run a random wallpaper in the current session
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
WALLPAPER=$(find "$HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" | shuf -n1)
pkill -f "mpvpaper.*$MONITOR"
nohup mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" >/dev/null 2>&1 &
disown


echo "Installation complete!"
