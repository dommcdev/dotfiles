#!/usr/bin/env bash
set -euo pipefail

# --- Detect distro ---
UNAME=$(uname -s)
if [[ "$UNAME" == "Darwin" ]]; then
  ID="macos"
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
ID="${ID:-unknown}"

# --- Detect power type ---
if grep -q "Battery" /sys/class/power_supply/*/type 2>/dev/null; then
  POWER_TYPE="laptop"
else
  POWER_TYPE="desktop"
fi

# --- Output (for debugging or sourcing) ---
echo "ID=$ID"
echo "POWER_TYPE=$POWER_TYPE"
