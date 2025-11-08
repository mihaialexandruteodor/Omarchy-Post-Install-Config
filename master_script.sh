#!/bin/sh

echo "Starting config for $(whoami)"

# Makes all .sh files in the scripts folder executable
chmod +x ./scripts/*.sh

./scripts/uninstaller.sh
