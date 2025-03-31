#!/bin/bash

# Plugins
source "$HOME/.config/zsh/plugins.zsh"

# Load other sources
sources = (
  ".config"
  ".functions"
)

for s in "${sources[@]}"; do
  for c in "$HOME/.config/zsh/${s}"/*.zsh; do
    source "${c}"
  done
  unset c
done
unset s

eval "$(starship init zsh)"
