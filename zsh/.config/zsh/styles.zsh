# Menu completion: cycle with Tab instead of showing all options at once
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: %p%s'

# Complete first match inline
zstyle ':completion:*' auto-menu yes
zstyle ':completion:*' list-prompt '%SMatches: %l%s'
