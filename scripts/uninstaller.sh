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

# Read the CSV file and uninstall each package
# Works with comma- or newline-separated values
while IFS= read -r line || [ -n "$line" ]; do
  # Replace commas with spaces so we can loop over each name
  for pkg in $(echo "$line" | tr ',' ' '); do
    pkg=$(echo "$pkg" | xargs) # trim whitespace
    if [ -n "$pkg" ]; then
      echo ">>> Uninstalling $pkg..."
      yay -Rns --noconfirm "$pkg"
    fi
  done
done < "$CSV_FILE"
