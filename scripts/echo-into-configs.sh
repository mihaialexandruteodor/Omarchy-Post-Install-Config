# add clipse to hyprland conf
echo -e "\nexec-once = clipse -listen # run listener on startup\nwindowrulev2 = float,class:(clipse) # ensure you have a floating window class set if you want this behavior\nwindowrulev2 = size 622 652,class:(clipse) # set the size of the window as necessary\nbind = SUPER, V, exec, alacritty --class clipse -e 'clipse' # Example: bind = SUPER, V, exec, alacritty --class clipse -e 'clipse'" >> ~/.config/hypr/hyprland.conf
# export conf for ashell
echo "exec-once = ashell" >> "$HOME/.config/hypr/hyprland.conf"
# comment waybar config autostart
sed -i 's/^\(exec-once *= *uwsm-app -- *waybar\)/# \1/' ~/.local/share/omarchy/default/hypr/autostart.conf

