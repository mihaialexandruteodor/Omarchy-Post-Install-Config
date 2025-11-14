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

#enable monitor config
sed -i '/monitor = , preferred, auto, 1/c\source = ~/.config/hypr/monitors.conf' ~/.config/hypr/hyprland.conf

# set Alacritty as terminal, Super + T
sed -i 's/^\$terminal = foot$/\$terminal = alacritty/' ~/.config/hypr/variables.conf

# add tab manager
git clone https://github.com/mihaialexandruteodor/quickshell-overview.git ~/.config/quickshell/overview
echo 'bind = Super, TAB, exec, qs ipc -c overview call overview toggle' >> ~/.config/hypr/hyprland.conf
echo 'exec-once = qs -c overview' >> ~/.config/hypr/hyprland.conf


# scheme
caelestia scheme set -n dynamic
