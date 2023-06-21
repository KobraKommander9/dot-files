#!/usr/bin/env fish

function copy_config -d "copy nvim config to devclone"
    if find ~/.config/nvim -type l -print -quit | grep --color -q .
        printf "Warning: this will deference symlinks and copy the files they point to\n" >&2
    end
    tar -chvf nvim.tar ~/.config/nvim >/dev/null
    set pod (kubectl get po -l tcn.com/development.owner=(id -nu | sed 's/\./-/g') -o custom-columns=name:.metadata.name --no-headers=true)
    printf "Copying nvim config to %s\n" $pod
    kubectl cp nvim.tar $pod:/home/vscode/.config
    kubectl exec $pod -- tar -xvf /home/vscode/.config/nvim.tar --strip-components=3 -C /home/vscode/.config
    rm nvim.tar
end
