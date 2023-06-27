#!/usr/bin/env fish

function zts -d "list zellij sessions"
    set zj_sessions (zellij list-sessions)
    if test -z $zj_sessions
        return 0
    end

    set selected (printf "%s\n" $zj_sessions | fzf --prompt="Zellij Session  " --height=~50% --layout=reverse --border --exit-0 --bind "ctrl-n:down,ctrl-e:up")
    if test -z $selected
        return 0
    else
        zellij attach $selected
    end
end
