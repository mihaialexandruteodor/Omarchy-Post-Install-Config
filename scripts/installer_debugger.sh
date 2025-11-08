#!/bin/sh
set -e

echo "Moving debugger.lua to LazyVim plugins folder..."

# Path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source and destination paths
CONFIG_SRC="$SCRIPT_DIR/debugger.lua"
CONFIG_DEST="$HOME/.config/nvim/lua/plugins/"

# Verify the file exists
if [ ! -f "$CONFIG_SRC" ]; then
  echo "Error: debugger.lua not found in script directory ($SCRIPT_DIR)."
  exit 1
fi

# Create destination directory if needed
mkdir -p "$CONFIG_DEST"

# Move the Lua config file
mv "$CONFIG_SRC" "$CONFIG_DEST"

echo "debugger.lua moved successfully."
echo "Run 'nvim' and LazyVim will install nvim-dap and nvim-dap-ui automatically."
