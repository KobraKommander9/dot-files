checkhealth() {
  echo "=== ZSH Health Check ==="

  local missing_cmd=0
  local missing_env=0
  local f dep env_var

  for f in ~/.config/zsh/configs/*.zsh ~/.config/zsh/functions/*.zsh; do
    [[ $(basename "$f") == "checkhealth.zsh" ]] && continue

    local filename=$(basename "$f")

    # Look for "requires: <commands>" comment
    if grep -E "# requires:" "$f" >/dev/null 2>&1; then
      local cmd_deps=($(grep -Eo "# requires:.*" "$f" | sed 's/# requires://;s/,/ /g'))
      for dep in "${cmd_deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
          echo "[-] Missing command '$dep' required by $filename"
          ((missing_cmd++))
        fi
      done
    fi

    # Look for "env: <env_vars>" comment
    if grep -E "# env:" "$f" >/dev/null 2>&1; then
      local env_deps=($(grep -Eo "# env:.*" "$f" | sed 's/# env://;s/,/ /g'))
      for env_var in "${env_deps[@]}"; do
        if [[ -z ${(P)env_var} ]]; then
          echo "[!] Missing env var '$env_var' required by $filename"
          ((missing_env++))
        fi
      done
    fi
  done

  echo "--- Summary ---"
  if ((missing == 0 && missing_env == 0)); then
    echo "[+] All requirements met!"
  else
    echo "[-] Found $missing_cmd missing command(s) and $missing_env missing env var(s)."
  fi
}
