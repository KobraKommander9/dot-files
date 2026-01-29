# requires: git

short-branch() {
    local b=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$b" ]]; then
        echo "${${b##*/}%%-*}"
    fi
}

gitclean() {
    git branch --format="%(refname:short)" | grep -Ev '^(master|main)$' | xargs -r git branch -D
}

alias gitmaster="git checkout master && git pull && gitclean"
