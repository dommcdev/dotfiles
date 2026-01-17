#!/bin/env bash

# Authenticate Tailscale (also sign in to Google in the process)
cd ~/dev/dotfiles && ./setup all/tailscale

# Set up chrome stuff - don't show cards/shortcuts, set wallpaper
# Set up nextcloud-client downloads folder sync. Ignore the first setup wizard - it won't work.
# Set up timeshift - open, pick disk to snapshot
