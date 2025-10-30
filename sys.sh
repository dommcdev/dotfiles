#!/usr/bin/env bash
set -euo pipefail

# --- Detect distro ---
UNAME=$(uname -s)
if [[ "$UNAME" == "Darwin" ]]; then
  ID="macos"
fi
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
fi
ID="${ID:-unknown}"

#Note to self - this needs more testing!
if [ -d /sys/class/power_supply/BAT0 ] || [ -d /sys/class/power_supply/macsmc-battery ]; then
  POWER=1
else
  POWER=0
fi

# --- Output requested value ---
case "${1:-all}" in
  id) echo "$ID" ;;
  power) echo "$POWER" ;;
  all) echo "$ID $POWER" ;;
esac
