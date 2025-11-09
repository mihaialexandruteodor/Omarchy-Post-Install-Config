# Omarchy post install config

[typecraft video](https://www.youtube.com/watch?v=d23jFJmcaMI)

[Omarchy wiki - remove packages](https://learn.omacom.io/2/the-omarchy-manual/66/other-packages?search=remove)

[Also check: Omarchy Cleaner](https://github.com/maxart/omarchy-cleaner)

## Check package name
``` pacman -Qo [program-name] ```

### Run just the remapper
``` chmod +x ./scripts/remapper.sh && ./scripts/remapper.sh ```

## Run master script
``` chmod +x ./master_script.sh && ./master_script.sh```

## Installs
- [x] Brave Browser
- [x] neofetch
- [x] eslint
- [x] gradle

## Uninstalls
- [x] Chromium

## Debugger
[Debug Adapter Wiki](https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)


## Themes
- [x] [Omarchy RetroPC Theme](https://github.com/rondilley/omarchy-retropc-theme)

------

# --- Use VMWare Workstation (Win/Linux) or Fusion (Mac) to test the script on an Omarchy VM ---
 Specify ``` Other Linux 6.x kernel 64-bit ``` during install, give the vm plenty of memory.

 Resolution might not be proper out of the box, this will prevent apps or the terminal to show.

 Use `Ctrl+Alt+F3` to open new TTY terminal
 Do the steps from [this guide](https://tillnet.se/index.php/2025/10/17/omarchy-on-vmware/):

 ```
sudo pacman -Sy nano

Start by installing vm-tools:
sudo pacman -S open-vm-tools
sudo systemctl enable vmtoolsd

Two config files need to be edited.

envs.conf
nano ~/.config/hypr/envs.conf

Add this line to the config and save:
env = LIBGL_ALWAYS_SOFTWARE, 1

monitors.conf
nano ~/.config/hypr/monitors.conf

Add(replace) these line to the config and save:
env = GDK_SCALE,1
and this line for a set resolution of 1920×1080:
monitor=,1920x1080@60,auto,1
or this line if you run in maximized window:
monitor=,preferred,auto,1

Reboot system

Done! Know it should work.
```
