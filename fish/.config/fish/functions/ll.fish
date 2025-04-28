#!/usr/bin/env fish

function ll
    eza -l -a --git --no-permissions --no-user $argv
end
