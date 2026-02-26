#!/bin/bash

# Ensure the script doesn't run if Hyprland isn't active
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "Hyprland is not running."
    exit 1
fi

# Define the path to Hyprland's event socket
SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Listen to the socket using socat and read it line by line
socat -U - UNIX-CONNECT:"$SOCKET_PATH" | while read -r line; do
    # Check if the line starts with the monitor events we care about
    if [[ "$line" == "monitoradded>>"* ]] || [[ "$line" == "monitorremoved>>"* ]]; then
        echo "Monitor hotplug detected! Reloading Hyprland..."
        sleep 3
        hyprctl reload
    fi
done
