#!/usr/bin/env fish

set fish_greeting

starship init fish | source
zoxide init fish | source
kubectl completion fish | source

set fish_key_bindings fish_user_key_bindings
