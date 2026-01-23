#!/usr/bin/env bash

# Launch the screensaver in Ghostty on all monitors.
# Usage: launch-screensaver [-l] [-m]

cmd="screensaver.sh"
font_size_override=""
monitor_mouse=false

while getopts "lm" opt; do
  case $opt in
    l)
      cmd="lavat -g -c fab387 -s 5 -b 13"
      font_size_override="12"
      ;;
    m)
      monitor_mouse=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Exit early if tte is not installed
if ! command -v tte &>/dev/null; then
  exit 1
fi

# Exit early if screensaver is already running
pgrep -f com.dominic.screensaver && exit 0

# Silently quit Walker on overlay
walker -q 2>/dev/null || true

# Hide cursor and ensure it's restored on exit
hyprctl keyword cursor:invisible true &>/dev/null
trap 'hyprctl keyword cursor:invisible false &>/dev/null' EXIT INT TERM

focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')

for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
  if [[ -n "$font_size_override" ]]; then
    font_size="$font_size_override"
  else
    scale=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$m\").scale")
    height=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$m\").height")
    font_size=$(echo "18 * $height / $scale / 1440" | bc)
  fi

  hyprctl dispatch focusmonitor "$m"
  hyprctl dispatch exec -- \
    ghostty --class=com.dominic.screensaver \
    --config-file="$HOME/dev/dotfiles/screensaver/ghostty-conf" \
    --font-size="$font_size" \
    -e "$cmd"
done

# Wait for screensaver to initialize and mouse to settle
sleep 0.5

if [[ "$monitor_mouse" == "true" ]]; then
  # Get initial cursor position
  get_cursor_pos() {
    hyprctl cursorpos -j | jq -r '"\(.x),\(.y)"'
  }
  initial_pos=$(get_cursor_pos)

  # Watch for mouse movement or screensaver exit
  while pgrep -f com.dominic.screensaver >/dev/null; do
    current_pos=$(get_cursor_pos)
    if [[ "$current_pos" != "$initial_pos" ]]; then
      pkill -f com.dominic.screensaver
      break
    fi
    sleep 0.1
  done
else
  # Wait for screensaver exit
  while pgrep -f com.dominic.screensaver >/dev/null; do
    sleep 0.5
  done
fi

hyprctl dispatch focusmonitor "$focused"
