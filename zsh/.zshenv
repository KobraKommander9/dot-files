#!/usr/bin/env zsh

[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if [[ -z $SSH_CONNECTION && -n $XDG_RUNTIME_DIR ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi
