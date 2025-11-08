#!/bin/bash
set -e

# Check for npm
if ! command -v npm &> /dev/null; then
  echo "Node.js/npm not found. Installing via pacman..."
  sudo pacman -S --needed nodejs npm
fi

# Install ESLint globally
echo "Installing ESLint globally..."
sudo npm install -g eslint

# Move the ESLint config file to home directory
CONFIG_FILE=".eslintrc.json"
TARGET_DIR="$HOME"

if [ -f "$CONFIG_FILE" ]; then
  echo "Copying $CONFIG_FILE to $TARGET_DIR"
  cp "$CONFIG_FILE" "$TARGET_DIR/$CONFIG_FILE"
else
  echo "$CONFIG_FILE not found!"
  exit 1
fi

echo "ESLint setup completed!"
echo "You can now run 'eslint --init' in your projects or use the config at $TARGET_DIR/$CONFIG_FILE"
