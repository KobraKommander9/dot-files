function fish_user_key_bindings
    fish_vi_key_bindings

    bind -s --preset -M insert \ct accept-autosuggestion
    bind -s --preset -M insert \cn down-line
    bind -s --preset -M insert \ce up-line

    bind -M insert -m default qn backward-char force-repaint
    bind -M insert qq 'commandline -i j'

    # default
    bind -s --preset -M default i forward-char # l
    bind -s --preset e up-or-search # k
    bind -s --preset n down-or-search # j

    bind -s --preset N end-of-line delete-char # J
    bind -s --preset E 'man (commandline -t) 2>/dev/null; or echo -n \a' # K

    bind -s --preset k forward-single-char forward-word backward-char # e
    bind -s --preset K forward-single-char forward-bigword backward-char # E

    bind -s --preset -m insert l repaint-mode # i
    bind -s --preset -m insert L beginning-of-line repaint-mode #I

    # visual
    bind -s --preset -M visual i forward-char # l
    bind -s --preset -M visual e up-line # k
    bind -s --preset -M visual n down-line # j

    bind -s --preset -M visual k forward-word # e
    bind -s --preset -M visual K forward-bigword # E
end
