# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
alias proton="/home/frosty/.steam/steam/steamapps/common/Proton\ -\ Experimental/proton"

protonrun() {
    if [ -z "$1" ]; then
        echo "Usage: protonrun /path/to/game.exe"
        return 1
    fi

    local exe="$1"
    local name=$(basename "$exe" .exe)
    local prefix="$HOME/.proton-prefixes/$name"

    mkdir -p "$prefix"

    STEAM_COMPAT_DATA_PATH="$prefix" \
    STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam" \
    "$HOME/.steam/steam/steamapps/common/Proton - Experimental/proton" run "$exe"
}

protonrun_deusex() {
    local exe="/home/frosty/Documents/steamgames/steamapps/common/Deus Ex/System/deusex.exe"
    local name
    name=$(basename "$exe" .exe)
    local prefix="$HOME/.proton-prefixes/$name"

    # Make sure the prefix exists
    mkdir -p "$prefix"

    # Run Proton with DXVK enabled, SDL using X11, and a dedicated prefix
    env SDL_VIDEODRIVER=x11 \
        STEAM_COMPAT_DATA_PATH="$prefix" \
        STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam" \
        PROTON_DXVK=1 \
        "$HOME/.steam/steam/steamapps/common/Proton - Experimental/proton" run "$exe"
}
