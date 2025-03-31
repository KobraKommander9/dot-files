#!/bin/bash

source "$HOME/.config/zsh/antigen.zsh"

# Load the oh-my-zsh library.
antigen use oh-my-zsh

antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle fzf # fuzzy finder
antigen bundle jenv # java version manager
antigen bundle z # z command for jumping around

antigen apply
