#!/usr/bin/env fish

set fish_greeting

starship init fish | source
zoxide init fish | source
kubectl completion fish | source
