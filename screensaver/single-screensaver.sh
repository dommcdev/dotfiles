#!/usr/bin/env bash

# Launch the test screensaver in Ghostty on all monitors.
# Usage: launch-screensaver-test <logo-path>

set -e

if [[ -z "$1" ]]; then
  echo "Usage: launch-screensaver-test <logo-path>"
  exit 1
fi

logo_path="$(realpath "$1")"

if [[ ! -f "$logo_path" ]]; then
  echo "Error: Logo file not found: $logo_path"
  exit 1
fi

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
  hyprctl dispatch focusmonitor "$m"
  hyprctl dispatch exec -- \
    ghostty --class=com.dominic.screensaver \
    --config-file="$HOME/dev/dotfiles/screensaver/ghostty-conf" \
    --font-size=18 \
    -e screensaver-test.sh "$logo_path"
done

hyprctl dispatch focusmonitor "$focused"
