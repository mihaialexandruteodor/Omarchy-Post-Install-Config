# Omarchy post install config

[typecraft video](https://www.youtube.com/watch?v=d23jFJmcaMI)

## Uninstalls
- [x] Grok webapp
- [x] Chromium

## Installs
- []

## Keybind modifications
- []


------

# --- VirtualBox VM Setup for Post-Install Script Testing ---

1. Create a new VM:
   - Open VirtualBox → "New"
   - Name the VM and select the target Linux distro
   - Allocate RAM and CPU (e.g., 2GB RAM, 2 CPU cores)
   - Create a virtual hard disk (VDI, dynamically allocated, ~20GB+)

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
