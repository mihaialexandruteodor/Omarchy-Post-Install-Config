# add clipse to hyprland conf
echo -e "\nexec-once = clipse -listen # run listener on startup\nwindowrulev2 = float,class:(clipse) # ensure you have a floating window class set if you want this behavior\nwindowrulev2 = size 622 652,class:(clipse) # set the size of the window as necessary\nbind = SUPER, V, exec, alacritty --class clipse -e 'clipse' # Example: bind = SUPER, V, exec, alacritty --class clipse -e 'clipse'" >> ~/.config/hypr/hyprland.conf

# export conf autostart command for ashell
echo 'exec-once = bash -c "sleep 1 && ashell"' >> "$HOME/.config/hypr/autostart.conf"
# move ashell custom config file
cp config.toml "$HOME/.config/ashell/config.toml"

# comment waybar config autostart
sed -i 's/^\(exec-once *= *uwsm-app -- *waybar\)/# \1/' ~/.local/share/omarchy/default/hypr/autostart.conf

# uncomment the window rounding option in looknfeel conf
sed -i 's/^# *rounding = 8/rounding = 8/' ~/.config/hypr/looknfeel.conf

