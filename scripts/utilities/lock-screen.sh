#!/usr/bin/env bash

# Already locked? Exit early.
pidof hyprlock && exit 0

# Kill screensaver before hyprlock activates (to prevent ghost frame on unlock)
pkill -f com.dominic.screensaver 2>/dev/null || true
sleep 0.1

hyprlock --no-fade-in &

#Notes
# idle_inhibit=3 in hypridle.conf makes the system wait for hyprlock to be "finished" before sleeping
# however, hyprlock reports being done a little prematurely - without the --no-fade-in flag the system will sleep
# before the lockscreen has fully rendered, resulting in a ghost half-lockscreen half-desktop image upon waking
# --immediate-render flag will render something immeditely, even if it is just a background color and white input box (no clock, etc)
