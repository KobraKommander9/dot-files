#!/usr/bin/env fish

function k --wraps kubectl
    kubectl $argv
end
