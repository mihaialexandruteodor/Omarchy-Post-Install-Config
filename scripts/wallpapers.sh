#!/bin/bash

# -------------------------
# Live Wallpaper Installer
# -------------------------

# 0️⃣ Determine correct home directory if running via sudo
if [ "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

echo "Configuring live wallpapers for $USER_HOME..."

# 1️⃣ Create wallpapers folder and download GitHub wallpapers
WALL_DIR="$USER_HOME/Documents/wallpapers/live"
echo "Downloading wallpapers to $WALL_DIR..."
mkdir -p "$WALL_DIR"
git clone --depth 1 https://github.com/mihaialexandruteodor/wallpaper-stash.git /tmp/wallpaper-stash
cp /tmp/wallpaper-stash/live/* "$WALL_DIR/"
rm -rf /tmp/wallpaper-stash
echo "Wallpapers downloaded."

# 2️⃣ Create Hyprland startup script
STARTUP_SCRIPT="$USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh"
echo "Creating Hyprland startup script at $STARTUP_SCRIPT..."
mkdir -p "$(dirname "$STARTUP_SCRIPT")"

cat > "$STARTUP_SCRIPT" << EOF
#!/bin/bash
# Start live wallpaper for Hyprland

echo "Starting live wallpaper..."

# wait until monitor is ready
for i in {1..10}; do
    MONITOR=\$(hyprctl monitors -j | jq -r '.[0].name')
    if [ -n "\$MONITOR" ]; then
        echo "Monitor detected: \$MONITOR"
        break
    fi
    echo "Waiting for monitor... (\$i)"
    sleep 1
done

# pick a random wallpaper
WALLPAPER=\$(find $WALL_DIR -maxdepth 1 -type f -name "*.mp4" | shuf -n1)
echo "Launching wallpaper: \$WALLPAPER"

# launch mpvpaper detached
nohup mpvpaper -o "--no-audio --loop-file=inf" "\$MONITOR" "\$WALLPAPER" >/dev/null 2>&1 &
disown
EOF

chmod +x "$STARTUP_SCRIPT"

# 3️⃣ Add it to hyprland.conf if not already present
HYPR_CONF="$USER_HOME/.config/hypr/hyprland.conf"
if ! grep -Fxq "exec-once=$STARTUP_SCRIPT" "$HYPR_CONF"; then
    echo "Adding exec-once line to hyprland.conf..."
    echo "exec-once=$STARTUP_SCRIPT" >> "$HYPR_CONF"
else
    echo "exec-once line already exists in hyprland.conf"
fi

# 4️⃣ Run a random wallpaper immediately in the current session
(
    echo "Starting live wallpaper for current session..."
    # wait for monitor
    while true; do
        MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
        [ -n "$MONITOR" ] && break
        echo "Waiting for monitor..."
        sleep 1
    done

    WALLPAPER=$(find "$WALL_DIR" -maxdepth 1 -type f -name "*.mp4" | shuf -n1)
    echo "Launching wallpaper: $WALLPAPER"

    pkill -f "mpvpaper.*$MONITOR"
    nohup mpvpaper -o "--no-audio --loop-file=inf" "$MONITOR" "$WALLPAPER" >/dev/null 2>&1 &
    disown
    echo "Live wallpaper started!"
) &
