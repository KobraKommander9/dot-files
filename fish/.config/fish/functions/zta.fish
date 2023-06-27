#!/usr/bin/env fish

function zta -d "attach to current directory zellij session"
    set zj_session (zellij list-sessions | grep (pwd))
    if test -z $zj_session
        zellij -s (pwd | awk '{gsub("/","%",$1); print $1;}')
    else
        zellij attach $zj_selected
    end
end
