#!/usr/bin/env fish

set -gx CLOUDSDK_PYTHON python

if test -f "$HOME/google-cloud-sdk/path.fish.inc"
    source "$HOME/google-cloud-sdk/path.fish.inc"
end
