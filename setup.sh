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
brew install stow zsh fish neovim

# Install WezTerm nightly
print_status "Installing WezTerm nightly..."
brew install --cask  wezterm@nightly

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

print_status "Setup complete! Please restart your terminal to apply changes." 