#!/bin/bash

# Nota bene - socat must be installed for this to run!

# 1. Wait until Hyprland creates its runtime directory
# This prevents the script from crashing if systemd starts it slightly before Hyprland is ready.
while ! ls -d "$XDG_RUNTIME_DIR/hypr/"* 1> /dev/null 2>&1; do
    sleep 1
done

# 2. Dynamically find the most recent Hyprland instance signature folder
HYPR_DIR=$(ls -td "$XDG_RUNTIME_DIR/hypr/"*/ | head -n 1)

# Strip the trailing slash to isolate just the signature string
SIGNATURE=$(basename "$HYPR_DIR")

# 3. Export the signature so hyprctl knows where to send the reload command
export HYPRLAND_INSTANCE_SIGNATURE="$SIGNATURE"

# 4. Define the socket path
SOCKET_PATH="${HYPR_DIR}.socket2.sock"

# Listen to the socket using socat and read it line by line
socat -U - UNIX-CONNECT:"$SOCKET_PATH" | while read -r line; do
    # Check if the line starts with the monitor events we care about
    if [[ "$line" == "monitoradded>>"* ]] || [[ "$line" == "monitorremoved>>"* ]]; then
        echo "Monitor hotplug detected! Reloading Hyprland..."
        notify-send "Hotplug detected"
        sleep 8
        hyprctl reload
        notify-send "Reloaded"
    fi
done
