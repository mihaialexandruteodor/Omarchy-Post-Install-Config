#!/bin/sh
set -e

echo "Moving LazyVim debugger configuration..."

# Use the current working directory as the source
CONFIG_SRC="$(pwd)/debugger.lua"
CONFIG_DEST="$HOME/.config/nvim/lua/plugins/"

# Verify the file exists
if [ ! -f "$CONFIG_SRC" ]; then
  echo "❌ Error: debugger.lua not found in current directory."
  exit 1
fi

# Create destination directory if needed
mkdir -p "$CONFIG_DEST"

# Move the Lua config file
mv "$CONFIG_SRC" "$CONFIG_DEST"

echo "Installing LazyVim debugger plugins (vanilla nvim-dap)..."

# Make sure dependencies are available
sudo pacman -S --needed --noconfirm neovim git

# Add debugger plugin definitions directly (optional if debugger.lua already has them)
cat <<'EOF' > "$CONFIG_DEST/debugger.lua"
return {
  -- Core DAP support
  { "mfussenegger/nvim-dap" },

  -- Optional UI for DAP
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },

  -- Optional virtual text for inline variable display
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },
}
EOF

# Sync LazyVim plugins
nvim --headless "+Lazy! sync" "+qall"

echo "✅ LazyVim debugger setup complete!"
