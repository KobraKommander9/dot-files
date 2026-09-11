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

wt() {
    local repo branch dir
    repo=$(git rev-parse --git-common-dir) || return 1
    repo=$(cd "$(dirname "$repo")" && pwd)
    branch="$1"; dir="$repo.worktrees/$branch"

    git -C "$repo" fetch origin --quiet
    git -C "$repo" worktree add -b "$branch" "$dir" origin/master || return 1

    [[ -f "$repo/.claude/settings.local.json" ]] && mkdir -p "$dir/.claude" && \
        ln -sf "$repo/.claude/settings.local.json" "$dir/.claude/settings.local.json"
    cd "$dir"
}

alias gitmaster="git checkout master && git pull && gitclean"
