#!/bin/sh

echo "Starting to uninstall undesired programs..."

# Get the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# CSV file path (same directory as script)
CSV_FILE="$SCRIPT_DIR/packages_uninstall.csv"

# Check if the CSV file exists
if [ ! -f "$CSV_FILE" ]; then
  echo "Error: CSV file not found at $CSV_FILE"
  exit 1
fi

while IFS= read -r line || [ -n "$line" ]; do
  # Replace commas with spaces, remove extra spaces
  line=$(echo "$line" | tr ',' ' ' | xargs)

  for pkg in $line; do
    if [ -n "$pkg" ]; then
      echo ">>> Uninstalling $pkg..."
      pacman -Rns --noconfirm "$pkg"
    fi
  done
done < "$CSV_FILE"
