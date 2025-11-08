#!/bin/sh

echo "Starting to install desired programs..."

# Get the directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# CSV file path (same directory as script)
CSV_FILE="$SCRIPT_DIR/packages_install.csv"

# Check if the CSV file exists
if [ ! -f "$CSV_FILE" ]; then
  echo "Error: CSV file not found at $CSV_FILE"
  exit 1
fi

# Update package database first
echo ">>> Updating package database..."
sudo yay -Syu --noconfirm

# Read each line of the CSV file
while IFS= read -r line || [ -n "$line" ]; do
  # Replace commas with spaces and clean up whitespace
  line=$(echo "$line" | tr ',' ' ' | xargs)

  for pkg in $line; do
    if [ -n "$pkg" ]; then
      echo ">>> Installing $pkg..."
      sudo yay -S --noconfirm --needed "$pkg"
    fi
  done
done < "$CSV_FILE"

