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
echo "Starting live wallpaper at login..."
# wait for monitor to be ready
for i in {1..10}; do
    MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
    if [ -n "$MONITOR" ]; then
        echo "Monitor detected: $MONITOR"
        break
    fi
    echo "Waiting for monitor to be ready... ($i)"
    sleep 1
done

# pick a random wallpaper safely
WALLPAPER=$(find "$HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" -print0 | shuf -zn1 | xargs -0)
echo "Launching wallpaper: $WALLPAPER"
mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" &
EOF
chmod +x "$USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh"

# 3️⃣ Add it to hyprland.conf if not already there
grep -qxF "exec = $USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" "$USER_HOME/.config/hypr/hyprland.conf" || \
echo "exec = $USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" >> "$USER_HOME/.config/hypr/hyprland.conf"
echo "Startup script added to hyprland.conf"

# 4️⃣ Immediately run a random wallpaper in the current session in background
(
    echo "Running a random wallpaper for current session..."
    # wait until monitor is ready
    while true; do
        MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
        if [ -n "$MONITOR" ]; then
            echo "Monitor detected: $MONITOR"
            break
        fi
        echo "Waiting for monitor to be ready..."
        sleep 1
    done

    WALLPAPER=$(find "$USER_HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" -print0 | shuf -zn1 | xargs -0)
    echo "Launching wallpaper: $WALLPAPER"

    pkill -f "mpvpaper.*$MONITOR"
    nohup mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" >/dev/null 2>&1 &
    disown
    echo "Live wallpaper started!"
) &
