#!/usr/bin/env bash

# Launch the screensaver in Ghostty on all monitors.
# Usage: launch-screensaver [force]

# Exit early if tte is not installed
if ! command -v tte &>/dev/null; then
  exit 1
fi

# Exit early if screensaver is already running
pgrep -f com.dominic.screensaver && exit 0

# Silently quit Walker on overlay
walker -q 2>/dev/null || true

focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')

for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
  scale=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$m\").scale")
  height=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$m\").height")
  font_size=$(echo "18 * $height / $scale / 1440" | bc)

  hyprctl dispatch focusmonitor "$m"
  hyprctl dispatch exec -- \
    ghostty --class=com.dominic.screensaver \
    --config-file="$HOME/dev/dotfiles/screensaver/ghostty-conf" \
    --font-size="$font_size" \
    -e screensaver.sh
done

hyprctl dispatch focusmonitor "$focused"
