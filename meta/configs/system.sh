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

# --- Detect power type ---
if grep -q "Battery" /sys/class/power_supply/*/type 2>/dev/null; then
  POWER="laptop"
else
  POWER="desktop"
fi

# --- Output (for debugging or sourcing) ---
echo "ID=$ID"
echo "POWER=$POWER"
