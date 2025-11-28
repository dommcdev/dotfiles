#!/bin/env bash

# Authenticate Tailscale (also sign in to Google in the process)
# Tailscale note: At least when I'm on the same network as it, having a device configured as a subnet router off will result in tailscale not working. run tailscale up without the --accept-routes flag and it will work (have internet connectivity) again. 
sudo tailscale up --accept-routes --reset --ssh
sudo tailscale set --operator=$USER

# Set up chrome stuff - don't show cards/shortcuts, set wallpaper
# Set up nextcloud-client downloads folder sync. Ignore the first setup wizard - it won't work.
# Set up sunshine - open with rofi, then go to localhost:47990 and set up creds (same as system)
# Set up timeshift - open, pick disk to snapshot
