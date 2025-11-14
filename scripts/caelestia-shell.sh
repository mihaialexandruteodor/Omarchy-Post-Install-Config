#!/bin/sh

# add it to autostart
echo 'exec-once = bash -c "caelestia shell -d"' >> "$HOME/.config/hypr/autostart.conf"

# add config
cp shell.json "$HOME/.config/caelestia/shell.json"
