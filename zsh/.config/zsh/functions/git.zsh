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

git-default-branch() {
    local repo=$1 base
    base=$(git -C "$repo" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null) || {
        git -C "$repo" remote set-head origin --auto >/dev/null 2>&1
        base=$(git -C "$repo" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
    }

    if [[ -z "$base" ]]; then
        local b
        for b in main master; do
            git -C "$repo" show-ref --verify --quiet "refs/remotes/origin/$b" && base="origin/$b" && break
        done
    fi

    [[ -n "$base" ]] && echo "$base"
}

wt() {
    local repo branch dir
    repo=$(git rev-parse --git-common-dir) || return 1
    repo=$(cd "$(dirname "$repo")" && pwd)
    branch="$1"; dir="$repo.worktrees/$branch"
    [[ -n "$branch" ]] || { print -u2 "usage: wt <branch>"; return 1; }

    git -C "$repo" fetch origin --quiet
    if git -C "$repo" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        git -C "$repo" worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1
    else
        git -C "$repo" worktree add -b "$branch" "$dir" $(git-default-branch "$repo") || return 1
    fi

    [[ -f "$repo/.claude/settings.local.json" ]] && mkdir -p "$dir/.claude" && \
        ln -sf "$repo/.claude/settings.local.json" "$dir/.claude/settings.local.json"
    cd "$dir"
}

gitmaster() {
    local base
    base=$(git-default-branch .) || return 1
    git checkout "${base#origin/}" && git pull && gitclean
}
