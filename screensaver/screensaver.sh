#!/usr/bin/env bash

# Run the screensaver using random effects from TTE.
# This script runs inside the terminal spawned by launch-screensaver.

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

printf '\033]11;rgb:00/00/00\007'  # Set background color to black
hyprctl keyword cursor:invisible true &>/dev/null

tty=$(tty 2>/dev/null)

while true; do
  tte -i ~/dev/dotfiles/screensaver/logo.txt \
    --frame-rate 120 --canvas-width 0 --canvas-height 0 --reuse-canvas --anchor-canvas c --anchor-text c \
    --random-effect --exclude-effects dev_worm \
    --no-eol --no-restore-cursor &

  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    if read -n1 -t 1 || ! screensaver_in_focus; then
      exit_screensaver
    fi
  done
done
