#!/usr/bin/env fish

set -gx GOPATH $HOME/go
set -gx GOROOT /usr/local/opt/go/libexec
set -gx GOBIN $GOPATH/bin

set -gx CGO_ENABLED 0

fish_add_path $GOBIN
fish_add_path $GOROOT/bin
