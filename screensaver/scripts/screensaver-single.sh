#!/usr/bin/env bash

# Run the test screensaver using tte print effect.
# Usage: screensaver-test.sh <logo-path>

if [[ -z "$1" ]]; then
  echo "Usage: screensaver-test.sh <logo-path>"
  exit 1
fi

logo_path="$1"

if [[ ! -f "$logo_path" ]]; then
  echo "Error: Logo file not found: $logo_path"
  exit 1
fi

screensaver_in_focus() {
  hyprctl activewindow -j | jq -e '.class == "com.dominic.screensaver"' >/dev/null 2>&1
}

exit_screensaver() {
  hyprctl keyword cursor:invisible false &>/dev/null || true
  pkill -x tte 2>/dev/null || true
  pkill -f com.dominic.screensaver 2>/dev/null || true
  exit 0
}

trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

center_text() {
  local lines=() max_width=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    lines+=("$line")
    ((${#line} > max_width)) && max_width=${#line}
  done
  for line in "${lines[@]}"; do
    local padding=$(( (max_width - ${#line}) / 2 ))
    printf "%*s%s\n" "$padding" "" "$line"
  done
}

printf '\033]11;rgb:00/00/00\007'  # Set background color to black
hyprctl keyword cursor:invisible true &>/dev/null

tty=$(tty 2>/dev/null)

while true; do
  center_text < "$logo_path" | tte \
    --frame-rate 120 --canvas-width 0 --canvas-height 0 --reuse-canvas --anchor-canvas c --anchor-text c \
    --no-eol --no-restore-cursor \
    thunderstorm & \

  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    if read -n1 -t 1 key || ! screensaver_in_focus; then
      if [[ "$key" == "n" ]]; then
        pkill -x tte 2>/dev/null || true
        break
      fi
      exit_screensaver
    fi
  done
done
