#!/usr/bin/env bash

# Locks the system using hyprlock, but not before ensuring the screensaver stopped.

# Lock the screen
pidof hyprlock || hyprlock &

# Avoid running screensaver when locked
sleep 2; pkill -f com.dominic.screensaver
