#!/bin/env bash

# Authenticate Tailscale (also sign in to Google in the process)
sudo tailscale set --operator=$USER
tailscale up --accept-routes --reset --ssh

# Set up nextcloud-client downloads folder sync. Ignore the first setup wizard - it won't work.
# Set up sunshine - open with rofi, then go to localhost:47990 and set up creds
