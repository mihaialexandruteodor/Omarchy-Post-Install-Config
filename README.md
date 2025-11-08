# Omarchy post install config

[typecraft video](https://www.youtube.com/watch?v=d23jFJmcaMI)

[Omarchy wiki - remove packages](https://learn.omacom.io/2/the-omarchy-manual/66/other-packages?search=remove)

[Also check: Omarchy Cleaner](https://github.com/maxart/omarchy-cleaner)

## Check package name
``` pacman -Qo [program-name] ```

## Make master script executable
``` chmod +x ./master_script.sh```

## Uninstalls
- [x] Chromium

## Installs
- []

## Extra
- [x] nvim-dap, a package that facilitates debugging in NeoVim

## Themes
- [x] [Omarchy RetroPC Theme](https://github.com/rondilley/omarchy-retropc-theme)

## Keybind modifications
- []


------

# --- VirtualBox VM Setup for Post-Install Script Testing ---

1. Create a new VM:
   - Open VirtualBox → "New"
   - Name the VM and select the target Linux distro
   - Allocate RAM and CPU (e.g., 2GB RAM, 2 CPU cores)
   - Create a virtual hard disk (VDI, dynamically allocated, ~20GB+)
   - Use Graphics Controller VBoxSVGA (Important!)

2. Install the Linux OS:
   - Start the VM and boot from the installation ISO
   - Complete the OS installation
   - Install any guest additions/tools if needed

3. Take a "Post-Install Clean" snapshot:
   - Shut down the VM after installation
   - Right-click the VM → Snapshots → Take Snapshot
   - Name it "Post-Install Clean" and add an optional description

4. Test your post-install script:
   - Boot the VM
   - Run your post-install script
   - Verify the changes

5. Revert to the clean snapshot for repeat testing:
   - Shut down the VM (or pause)
   - Right-click VM → Snapshots → Restore → select "Post-Install Clean"
   - Start VM again and run another test iteration
