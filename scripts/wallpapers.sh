#!/bin/bash

# 0️⃣ Determine the correct home directory for the logged-in user
if [ "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

# 1️⃣ Create wallpapers folder and download GitHub wallpapers
mkdir -p "$USER_HOME/Documents/wallpapers/live"
git clone --depth 1 https://github.com/mihaialexandruteodor/wallpaper-stash.git /tmp/wallpaper-stash
cp /tmp/wallpaper-stash/live/* "$USER_HOME/Documents/wallpapers/live/"
rm -rf /tmp/wallpaper-stash

# 2️⃣ Create the Hyprland startup script
mkdir -p "$USER_HOME/.config/hypr/scripts"
cat > "$USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" << 'EOF'
#!/bin/bash
# wait for monitor to be ready
for i in {1..5}; do
    MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
    [ -n "$MONITOR" ] && break
    sleep 1
done
# pick a random wallpaper safely, even with spaces in filenames
WALLPAPER=$(find "$HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" -print0 | shuf -zn1 | xargs -0)
mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" &
EOF
chmod +x "$USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh"

# 3️⃣ Add it to hyprland.conf if not already there
grep -qxF "exec-once = $USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" "$USER_HOME/.config/hypr/hyprland.conf" || \
echo "exec-once = $USER_HOME/.config/hypr/scripts/start-live-wallpaper.sh" >> "$USER_HOME/.config/hypr/hyprland.conf"

# 4️⃣ Immediately run a random wallpaper in the current session
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
WALLPAPER=$(find "$USER_HOME/Documents/wallpapers/live/" -maxdepth 1 -type f -name "*.mp4" -print0 | shuf -zn1 | xargs -0)
pkill -f "mpvpaper.*$MONITOR"
nohup mpvpaper -o "no-audio loop" "$MONITOR" "$WALLPAPER" >/dev/null 2>&1 &
disown
