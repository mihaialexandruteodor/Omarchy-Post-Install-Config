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

# 2️⃣ Create the Hyprland autostart script
echo "Creating Hyprland autostart script..."
mkdir -p "$USER_HOME/.config/hypr/scripts"
cat > "$USER_HOME/.config/hypr/scripts/autostart-wallpaper.sh" << 'EOF'
#!/bin/bash
echo "Starting live wallpaper at login..."
# wait for monitor to be ready
for i in {1..15}; do
    MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
    if [ -n "$MONITOR" ]; then
        echo "Monitor detected: $MONITOR"
        break
    fi
    echo "Waiting for monitor... ($i)"
    sleep 1
done

# pick a random wallpaper
WALLPAPER=$(find "$HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" -print0 | shuf -zn1 | xargs -0)
echo "Launching wallpaper: $WALLPAPER"
nohup mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" >/dev/null 2>&1 &
disown
EOF
chmod +x "$USER_HOME/.config/hypr/scripts/autostart-wallpaper.sh"

# 3️⃣ Add the autostart script to hyprland.conf if not already there
if ! grep -qxF "exec = $USER_HOME/.config/hypr/scripts/autostart-wallpaper.sh" "$USER_HOME/.config/hypr/hyprland.conf"; then
    echo "Adding autostart script to hyprland.conf..."
    echo "exec = $USER_HOME/.config/hypr/scripts/autostart-wallpaper.sh" >> "$USER_HOME/.config/hypr/hyprland.conf"
else
    echo "Autostart script already in hyprland.conf"
fi

# 4️⃣ Immediately run a random wallpaper for the current session
(
    echo "Starting live wallpaper for current session..."
    # wait until monitor is ready
    for i in {1..15}; do
        MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
        if [ -n "$MONITOR" ]; then
            echo "Monitor detected: $MONITOR"
            break
        fi
        echo "Waiting for monitor... ($i)"
        sleep 1
    done

    WALLPAPER=$(find "$USER_HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" -print0 | shuf -zn1 | xargs -0)
    echo "Launching wallpaper: $WALLPAPER"

    pkill -f "mpvpaper.*$MONITOR"
    nohup mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" >/dev/null 2>&1 &
    disown
    echo "Live wallpaper started!"
) &
