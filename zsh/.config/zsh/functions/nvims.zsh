# requires: nvim, fzf

function nvims() {
    if [[ -n "$1" ]] then
        local target_app="$1"
        [[ "$target_app" == "default" ]] && target_app=""
        NVIM_APPNAME="$target_app" nvim "${@:2}"
        return 0
    fi

    local config_dir="$HOME/dot-files/nvim/.config"
    local items=($(ls -d $config_dir/*/ 2>/dev/null | xargs -n 1 basename))

    items=("${items[@]/nvim/default}")

    local config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0 --bind "ctrl-n:down,ctrl-e:up")

    if [[ -z "$config" ]]; then
        echo "Nothing selected"
        return 0
    elif [[ "$config" == "default" ]]; then
        config=""
    fi

    NVIM_APPNAME="$config" nvim "$@"
}
