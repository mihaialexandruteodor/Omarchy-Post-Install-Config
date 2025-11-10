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
mkdir -p ~/Documents/wallpapers/live && git clone --depth 1 https://github.com/mihaialexandruteodor/wallpaper-stash.git /tmp/wallpaper-stash && cp /tmp/wallpaper-stash/live/* ~/Documents/wallpapers/live/ && rm -rf /tmp/wallpaper-stash

mkdir -p ~/.config/hypr/scripts && \
cat > ~/.config/hypr/scripts/start-live-wallpaper.sh << 'EOF'
#!/bin/bash
# Get the first monitor name
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')

# Pick a random mp4 from the live wallpapers folder
WALLPAPER=$(find "$HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" | shuf -n1)

# Start mpvpaper in the background
mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" &
EOF
chmod +x ~/.config/hypr/scripts/start-live-wallpaper.sh && \
grep -qxF 'exec-once = ~/.config/hypr/scripts/start-live-wallpaper.sh' ~/.config/hypr/hyprland.conf || \
echo 'exec-once = ~/.config/hypr/scripts/start-live-wallpaper.sh' >> ~/.config/hypr/hyprland.conf



echo "✅ Installation complete!"
