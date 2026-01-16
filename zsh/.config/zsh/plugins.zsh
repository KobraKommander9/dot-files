source "$HOME/.config/zsh/antigen.zsh"

# Load the oh-my-zsh library.
antigen use oh-my-zsh

###############
### PLUGINS ###
###############

# Inline suggestions
antigen bundle zsh-users/zsh-autosuggestions

# Syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle colored-man-pages
antigen bundle command-not-found

# antigen bundle fzf # fuzzy finder
# antigen bundle jenv # java version manager

###############
###  APPLY  ###
###############

antigen apply
