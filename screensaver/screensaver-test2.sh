#!/usr/bin/env bash

# Run the test screensaver cycling through all logos in order.
# Usage: screensaver-test2.sh

PHRASES_DIR="$HOME/dev/dotfiles/screensaver/phrases"

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

# Get all phrase files sorted alphabetically
mapfile -t logos < <(find "$PHRASES_DIR" -type f -name '*.txt' | sort)

if [[ ${#logos[@]} -eq 0 ]]; then
  echo "Error: No phrase files found in $PHRASES_DIR"
  exit 1
fi

index=0

while true; do
  logo_path="${logos[$index]}"
  
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

  # Move to next logo, wrap around
  index=$(( (index + 1) % ${#logos[@]} ))
done
