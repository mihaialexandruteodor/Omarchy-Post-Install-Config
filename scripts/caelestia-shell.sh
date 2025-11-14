#!/bin/sh

# add it to autostart
#echo 'exec-once = bash -c "caelestia shell -d"' >> "$HOME/.config/hypr/autostart.conf"
#echo 'exec-once = bash -c "caelestia scheme -n dynamic"' >> "$HOME/.config/hypr/autostart.conf"

# add config
mkdir $HOME/.config/caelestia
cp shell.json "$HOME/.config/caelestia/shell.json"

# install the dots
git clone https://github.com/caelestia-dots/caelestia.git ~/.local/share/caelestia && ~/.local/share/caelestia/install.fish 1

# monitors conf
cp monitors.conf "$HOME/.config/hypr/monitors.conf"

# scheme
caelestia scheme set -n dynamic
