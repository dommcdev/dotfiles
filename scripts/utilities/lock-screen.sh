#!/usr/bin/env bash

# Already locked? Exit early.
pidof hyprlock && exit 0

# Kill screensaver before hyprlock activates (to prevent ghost frame on unlock)
pkill -f com.dominic.screensaver 2>/dev/null || true
sleep 0.1

hyprlock --immediate-render

