#!/bin/sh
set -e

echo "Moving debugger.lua to LazyVim plugins folder..."

# Path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source and destination paths
CONFIG_SRC="$SCRIPT_DIR/debugger.lua"
CONFIG_SRC_NVIM="$SCRIPT_DIR/nvim-java.lua"
CONFIG_DEST="$HOME/.config/nvim/lua/plugins/"

# Verify the debugger file exists
if [ ! -f "$CONFIG_SRC" ]; then
  echo "Error: debugger.lua not found in script directory ($SCRIPT_DIR)."
  exit 1
fi

# Verify the nmvim debug file exists
if [ ! -f "$CONFIG_SRC_NVIM" ]; then
  echo "Error: nvim-java.lua not found in script directory ($SCRIPT_DIR)."
  exit 1
fi

# Create destination directory if needed
mkdir -p "$CONFIG_DEST"

# Move the Lua config files
mv "$CONFIG_SRC" "$CONFIG_DEST"
mv "$CONFIG_SRC_NVIM" "$CONFIG_DEST"

echo "files moved successfully."
