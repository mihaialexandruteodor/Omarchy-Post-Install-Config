#!/bin/sh
set -e

echo "Installing Neovim debugger configs..."

# Path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source and destination
SRC_DIR="$SCRIPT_DIR/debugger-nvim"
DEST_DIR="$HOME/.config/nvim"

# --- Verify source folder exists ---
if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Source folder '$SRC_DIR' not found!"
  exit 1
fi

# --- Create destination folder if needed ---
mkdir -p "$DEST_DIR"

# --- Copy files recursively, overwriting existing ones ---
echo "Copying files from $SRC_DIR to $DEST_DIR..."
cp -r "$SRC_DIR"/* "$DEST_DIR"/

echo "Files copied successfully!"

