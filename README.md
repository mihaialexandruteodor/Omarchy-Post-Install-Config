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
