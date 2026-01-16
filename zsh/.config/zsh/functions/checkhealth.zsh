checkhealth() {
  echo "=== ZSH Health Check ==="

  local missing=0
  local f dep

  for f in ~/.config/zsh/configs/*.zsh ~/.config/zsh/functions/*.zsh; do
    [[ $(basename "$f") == "checkhealth.zsh" ]] && continue

    # Look for "requires: <commands>" comment
    grep -E "# requires:" "$f" >/dev/null 2>&1 || continue

    # Extract required commands from comment
    deps=($(grep -Eo "# requires:.*" "$f" | sed 's/# requires://;s/,/ /g'))
    for dep in "${deps[@]}"; do
      if ! command -v "$dep" >/dev/null 2>&1; then
        echo "Missing command '$dep' required by $(basename "$f")"
        ((missing++))
      fi
    done
  done

  if ((missing == 0)); then
    echo "All required commands found!"
  else
    echo "Found $missing missing command(s)."
  fi
}
