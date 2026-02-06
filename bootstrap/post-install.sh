#!/bin/env bash

xdg-open https://accounts.google.com
tailscale up
bash ~/dev/dotfiles/setup dev/gitrepos
bash ~/.local/bin/enroll-fingerprints

# Set up chrome stuff - don't show cards/shortcuts, set wallpaper
# Set up timeshift - open, pick disk to snapshot
