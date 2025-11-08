#!/bin/sh

# Path to Hyprland bindings config
CONFIG_FILE="$HOME/.config/hypr/bindings.conf"
BACKUP_FILE="$CONFIG_FILE.bak"

# CSV file path (same directory as script)
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CSV_FILE="$SCRIPT_DIR/remaps.csv"

echo "Remapping Hyprland bindings based on CSV..."

# Check files
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Hypr bindings not found at $CONFIG_FILE"
  exit 1
fi

if [ ! -f "$CSV_FILE" ]; then
  echo "Error: CSV file not found at $CSV_FILE"
  exit 1
fi

# Backup current config
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "Backup created at $BACKUP_FILE"

# Create a temporary file to store edits
TMP_FILE=$(mktemp)

# Copy current config
cp "$CONFIG_FILE" "$TMP_FILE"

# Process CSV line by line
while IFS=, read -r original remap || [ -n "$original" ]; do
  # Skip empty or commented lines
  if [ -z "$original" ] || echo "$original" | grep -qE '^\s*#'; then
    continue
  fi

  # Trim spaces
  original=$(echo "$original" | xargs)
  remap=$(echo "$remap" | xargs)

  if [ -n "$original" ] && [ -n "$remap" ]; then
    echo "Remapping '$original' → '$remap'"
    # Replace in file (use sed safely)
    sed -i "s|\b$original\b|$remap|g" "$TMP_FILE"
  fi
done < "$CSV_FILE"

# Move updated version back
mv "$TMP_FILE" "$CONFIG_FILE"
echo "Remapping complete. Updated config saved at $CONFIG_FILE"
