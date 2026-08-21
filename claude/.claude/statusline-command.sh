#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

GREEN="\033[0;32m"
MAGENTA="\033[0;35m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
RESET="\033[0m"

pct_color() {
  local pct="$1"
  local warn="${2:-40}"
  local err="${3:-80}"

  if [ "$pct" -ge $err ]; then
    echo "$RED"
  elif [ "$pct" -ge $warn ]; then
    echo "$YELLOW"
  else
    echo "$GREEN"
  fi
}

make_bar() {
  local pct="$1"
  local bar_width="${2:-10}"

  local filled=$((pct * bar_width / 100))
  local empty=$((bar_width - filled))
  local bar=""

  local color=$(pct_color "$pct")

  [ "$filled" -gt 0 ] && printf -v fill "%${filled}s" && bar="${fill// /▓}"
  [ "$empty" -gt 0 ] && printf -v pad "%${empty}s" && bar="${bar}${pad// /░}"

  echo "${color}${bar} ${pct}%${RESET}"
}

fmt_limit() {
  local label="$1"
  local pct=$(printf '%.0f' "$2")
  local color=$(pct_color "$pct" 50)
  echo "${label}: ${color}${pct}%${RESET}"
}

ctx_bar=$(make_bar "$ctx_pct")
limits=""
[ -n "$five_pct" ] && limits="$(fmt_limit '5h' "$five_pct")"
[ -n "$week_pct" ] && limits="${limits:+$limits }$(fmt_limit '7d' "$week_pct")"

statusline=$(echo -e "${MAGENTA}[${model}]${RESET} ${ctx_bar}")
[ -n "$limits" ] && echo -e "$statusline | $limits" || echo "$statusline"
