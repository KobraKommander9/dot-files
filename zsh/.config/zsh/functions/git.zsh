# requires: git

short-branch() {
  # Get current branch, silent if git not available or not in a repo
  local b
  b=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  [[ -z $b ]] && return

  # Return last part after slash, or first part before dash, or full branch
  echo "${${b##*/}%%-*}"
}

gitclean() {
  git branch --format="%(refname:short)" | grep -Ev '^(master|main)$' | xargs -r git branch -D
}

alias gitmaster="git checkout master && git pull && gitclean"
