#!/usr/bin/env bash

# Locks the system using hyprlock, but not before ensuring the screensaver stopped.

# Lock the screen
pidof hyprlock || hyprlock --immediate --no-fade-in &

# Avoid running screensaver when locked
pkill -f com.dominic.screensaver
