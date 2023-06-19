#!/usr/bin/env fish

# linkerd
fish_add_path $HOME/.linkerd2/bin/

set -gx CLOUDSDK_PYTHON python

if test -f "$HOME/google-cloud-sdk/path.fish.inc"
    source "$HOME/google-cloud-sdk/path.fish.inc"
end
