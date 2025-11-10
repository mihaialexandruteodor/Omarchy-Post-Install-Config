#!/bin/bash

# 0️⃣ Determine the correct home directory for the logged-in user
if [ "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

echo "Configuring live wallpapers for $USER_HOME..."

# 1️⃣ Create wallpapers folder and download GitHub wallpapers
echo "Downloading wallpapers..."
mkdir -p "$USER_HOME/Documents/wallpapers/live"
git clone --depth 1 https://github.com/mihaialexandruteodor/wallpaper-stash.git /tmp/wallpaper-stash
cp /tmp/wallpaper-stash/live/* "$USER_HOME/Documents/wallpapers/live/"
rm -rf /tmp/wallpaper-stash
echo "Wallpapers downloaded to $USER_HOME/Documents/wallpapers/live"

# 2️⃣ Create the Hyprland startup script
echo "Creating Hyprland startup script..."
mkdir -p "$USER_HOME/.config/hypr/scripts"
cat > "$USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" << 'EOF'
#!/bin/bash
# wait a couple of seconds for Hyprland to be ready
sleep 2
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
WALLPAPER=$(find "$HOME/Documents/wallpapers/live/" -type f -name "*.mp4" | shuf -n1)
echo "Launching live wallpaper: $WALLPAPER on $MONITOR"
mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER"
EOF
chmod +x "$USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh"

# 3️⃣ Add it to hyprland.conf if not already there
if ! grep -qxF "exec-once = $USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" "$USER_HOME/.config/hypr/hyprland.conf"; then
    echo "exec-once = $USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" >> "$USER_HOME/.config/hypr/hyprland.conf"
    echo "Startup script added to hyprland.conf"
else
    echo "Startup script already in hyprland.conf"
fi

# 4️⃣ Immediately run a random wallpaper in the current session in background
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
WALLPAPER=$(find "$USER_HOME/Documents/wallpapers/live/" -type f -name "*.mp4" | shuf -n1)
echo "Starting random wallpaper for current session: $WALLPAPER on $MONITOR"
pkill -f "mpvpaper.*$MONITOR"
mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" &
