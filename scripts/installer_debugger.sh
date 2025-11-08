#!/bin/sh
set -e

echo "Installing Neovim plugin configs for LazyVim..."

# Path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source files
DEBUGGER_SRC="$SCRIPT_DIR/debugger.lua"
JAVA_SRC="$SCRIPT_DIR/java.lua"
NVIM_JAVA_SRC="$SCRIPT_DIR/nvim-java.lua"

# Destination folder
CONFIG_DEST="$HOME/.config/nvim/lua/plugins/"

# --- Verify files exist ---
for FILE in "$DEBUGGER_SRC" "$JAVA_SRC" "$NVIM_JAVA_SRC"; do
  if [ ! -f "$FILE" ]; then
    echo "Error: $(basename "$FILE") not found in $SCRIPT_DIR"
    exit 1
  fi
done

# --- Create destination directory if it doesn't exist ---
mkdir -p "$CONFIG_DEST"

# --- Copy all files ---
cp "$DEBUGGER_SRC" "$JAVA_SRC" "$NVIM_JAVA_SRC" "$CONFIG_DEST"

echo "Files copied successfully to: $CONFIG_DEST"
echo "Copied files:"
ls -1 "$CONFIG_DEST" | grep -E 'debugger\.lua|java\.lua|nvim-java\.lua' || echo "No files found!"
