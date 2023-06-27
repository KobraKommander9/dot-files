#!/usr/bin/env fish

function nvims
    if not test -z "$argv[1]"
        NVIM_APPNAME=$argv[1] nvim $argv[2..-1]
        return 0
    end

    set items default KobraVim blank test LazyVim
    set config (printf "%s\n" $items | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0 --bind "ctrl-n:down,ctrl-e:up")
    if test -z $config
        echo "Nothing selected"
        return 0
    else if test $config = default
        set config ""
    end
    NVIM_APPNAME=$config nvim $argv
end
