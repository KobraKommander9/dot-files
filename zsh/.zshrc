#!/usr/bin/env zsh

# General
source "$HOME/.config/zsh/plugins.zsh"
source "$HOME/.config/zsh/keybinds.zsh"
source "$HOME/.config/zsh/styles.zsh"

# Autocompletions
autoload -Uz compinit
compinit

# Load other sources
sources=(
    "configs"
    "functions"
)

for s in "${sources[@]}"; do
    for c in "$HOME/.config/zsh/${s}"/*.zsh; do
        source "${c}"
    done
    unset c
done
unset s

eval "$(starship init zsh)"
