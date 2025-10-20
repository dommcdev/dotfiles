#!/bin/env bash

# Authenticate Tailscale (also sign in to Google in the process)
sudo tailscale up --accept-routes --reset

# Set up nextcloud-client downloads folder sync. Ignore the first setup wizard - it won't work.
