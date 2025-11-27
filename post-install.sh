#!/bin/env bash

# Authenticate Tailscale (also sign in to Google in the process)
sudo tailscale up --accept-routes --reset --ssh
sudo tailscale set --operator=$USER

# Set up chrome stuff - don't show cards/shortcuts, set wallpaper
# Set up nextcloud-client downloads folder sync. Ignore the first setup wizard - it won't work.
# Set up sunshine - open with rofi, then go to localhost:47990 and set up creds (same as system)
# Set up timeshift - open, pick disk to snapshot
