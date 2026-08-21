# requires: git, stow

# Report ~/.claude config that isn't linked into the dotfiles repo, plus
# anything Claude wrote through a link that hasn't been committed yet.
claude-strays() {
  local pkg="${DOTFILES:-$HOME/dot-files}/claude/.claude"
  local target="$HOME/.claude"

  if [[ ! -d $pkg ]]; then
    echo "[-] No claude package at $pkg"
    return 1
  fi

  # Runtime state Claude Code owns, plus deliberately machine-local config.
  # Anything not listed here is reported.
  local -a ignore=(
    .DS_Store .credentials.json .git .gitignore .last-cleanup
    .last-update-result.json backups cache downloads file-history
    history.jsonl ide logs paste-cache plugins policy-limits.json
    projects remote-settings.json session-env sessions shell-snapshots
    statsig stats-cache.json tasks telemetry todos
    CLAUDE.local.md settings.local.json
  )

  local -a detached=() strays=()
  local entry name

  for entry in $target/*(ND); do
    name=${entry:t}
    (( ${ignore[(Ie)$name]} )) && continue
    [[ -L $entry ]] && continue
    if [[ -e $pkg/$name ]]; then
      detached+=($name)
    else
      strays+=($name)
    fi
  done

  local changes=$(git -C $pkg status --porcelain -- . 2>/dev/null)
  local issues=$(( ${#detached} + ${#strays} ))
  [[ -n $changes ]] && (( issues++ ))

  if (( ${#detached} )); then
    echo "[-] Detached (tracked in the repo, but real in ~/.claude):"
    printf '      %s\n' $detached
    echo "    compare with $pkg, then: stow -R -t ~ claude"
  fi

  if (( ${#strays} )); then
    echo "[!] Untracked (created outside the repo):"
    printf '      %s\n' $strays
    echo "    adopt with: mv ~/.claude/<name> $pkg/ && stow -R -t ~ claude"
  fi

  if [[ -n $changes ]]; then
    echo "[!] Uncommitted in the claude package:"
    printf '      %s\n' ${(f)changes}
  fi

  (( issues )) || echo "[+] ~/.claude is fully linked and committed"
}
