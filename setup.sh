#!/bin/bash

# Exit on error
set -e

# Function to print status messages
print_status() {
    echo -e "\n\033[1;34m==>\033[0m \033[1m$1\033[0m"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not installed
if ! command_exists brew; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install required packages
print_status "Installing required packages..."
brew install stow zsh fish neovim go qmk/qmk/qmk

# Install go tools
print_status "Installing go tools..."
go install github.com/mgechev/revive@latest

# Install WezTerm nightly
if ! command_exists wezterm; then
    print_status "Installing WezTerm nightly..."
    brew install --cask  wezterm@nightly
else
    print_status "Updating WezTerm nightly..."
    brew upgrade --cask wezterm@nightly --no-quarantine --greedy-latest
fi

# Install bundled fonts
print_status "Installing bundled fonts..."
FONTS_DIR="$HOME/Library/Fonts"
mkdir -p "$FONTS_DIR"

for font in fonts/*.ttf; do
    if [ -f "$font" ]; then
        font_name=$(basename "$font")
        target_path="$FONTS_DIR/$font_name"
        if [ ! -f "$target_path" ]; then
            cp "$font" "$target_path"
            print_status "Installed font: $font_name"
        else
            print_status "Font already installed: $font_name"
        fi
    fi
done

# Create ~/.config directory if it doesn't exist
print_status "Creating ~/.config directory..."
mkdir -p ~/.config

# Use stow to symlink dotfiles
print_status "Setting up dotfiles using GNU Stow..."
for dir in fish nvim wezterm zsh; do
    if [ -d "$dir" ]; then
        print_status "Setting up $dir..."
        stow -v -R -t ~ "$dir"
    fi
done

# Set fish as default shell
print_status "Setting fish as default shell..."
FISH_PATH=$(which fish)
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi
chsh -s "$FISH_PATH"

# Setup qmk
print_status "Setting up qmk..."
qmk config user.keyboard=moonlander user.keymap=colemak
git clone git@github.com:qmk/qmk_firmware.git ~/qmk_firmware
git clone git@github.com:KobraKommander9/moonlander_colemak_qmk.git ~/qmk_firmware/keyboards/moonlander/keymaps/colemak

print_status "Setup complete! Please restart your terminal to apply changes." 