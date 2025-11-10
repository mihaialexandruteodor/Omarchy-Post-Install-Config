#!/bin/sh

echo "Starting to install desired programs..."

# pacman installs first
sudo pacman -S --noconfirm mpv

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CSV_FILE="$SCRIPT_DIR/packages_install.csv"

if [ ! -f "$CSV_FILE" ]; then
  echo "Error: CSV file not found at $CSV_FILE"
  exit 1
fi

echo ">>> Updating package database..."
yay -Syu --noconfirm

while IFS= read -r line || [ -n "$line" ]; do
  line=$(echo "$line" | tr ',' ' ' | xargs)

  for pkg in $line; do
    if [ -z "$pkg" ] || echo "$pkg" | grep -qE '^\s*#'; then
      continue
    fi

    echo ">>> Installing $pkg..."
    yay -S --noconfirm --needed "$pkg"
  done
done < "$CSV_FILE"

echo "Installation complete!"
