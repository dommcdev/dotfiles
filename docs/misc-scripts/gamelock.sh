#!/bin/env bash

# Note - to run via ssh do
# systemd-run --user --pty --wait bash .local/bin/gamelock

# This is intended for a linux mint system

# --- Configuration ---
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON="$DIR/snorelax.png"

# Game Definitions
GAME_LIST="supertuxkart supertux zsnes bsnes"
# Auto-generate regex from list (replace spaces with pipes)
GAMES_REGEX="${GAME_LIST// /|}"

# Warning Times (in seconds)
# Set these to 540 (9m) and 60 (1m) for production.
WARN_1_DURATION=15 
WARN_2_DURATION=15

# Default Lockout Duration (in minutes)
LOCKOUT_DURATION=30

# Systemd Unit Names
UNIT_ENFORCER="game-lockout-enforcer"
UNIT_ENDER="game-lockout-ender"

# --- Functions ---

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -r, --remove          Stop the active lockout immediately."
    echo "  -t, --time <minutes>  Set lockout duration (default: 30)."
    echo "  -h, --help            Show this help message."
    exit 1
}

send_notify() {
    notify-send -i "$ICON" "$1" "$2"
}

stop_lockout() {
    echo "Stopping lockout..."
    # Stop the repeating killer
    systemctl --user stop "${UNIT_ENFORCER}.timer" 2>/dev/null
    
    # Stop the scheduled ending task (prevent it from running later)
    systemctl --user stop "${UNIT_ENDER}.timer" 2>/dev/null
    
    # Reset failed states if any
    systemctl --user reset-failed 2>/dev/null
    systemctl --user daemon-reload 2>/dev/null
}

# --- Argument Parsing ---

MODE="START"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r|--remove)
            MODE="REMOVE"
            shift
            ;;
        -t|--time)
            if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
                LOCKOUT_DURATION="$2"
                shift 2
            else
                echo "Error: --time requires a numeric argument (minutes)."
                exit 1
            fi
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# --- Execution ---

if [[ "$MODE" == "REMOVE" ]]; then
    stop_lockout
    send_notify "Lockdown Lifted" "You are free to resume your game(s) now."
    exit 0
fi

# 1. Reset/Ensure no previous timers are clashing
stop_lockout

# 2. Warning Phase
zenity --info --title="Dominic is coming home!" \
    --text="Get to a break-off point now.\n($((WARN_1_DURATION / 60)) mins remaining)" \
    --timeout=5

sleep "$WARN_1_DURATION"

zenity --warning --title="URGENT" \
	--text="Games will be killed in $((WARN_2_DURATION / 60)) minutes(s)!\nSave NOW." \
    --timeout=10

sleep "$WARN_2_DURATION"

# 3. Graceful Close
echo "Attempting graceful close..."
for game in $GAME_LIST; do
    wmctrl -c "$game" || true
done

# 4. Start the Enforcer (Repeatedly kills games every minute)
# We name the unit explicitly so we can target it with --remove later
systemd-run --user \
    --unit="$UNIT_ENFORCER" \
    --on-active=1s \
    --timer-property="OnUnitActiveSec=1m" \
    pkill -f "$GAMES_REGEX"

echo "Lockout started for $LOCKOUT_DURATION minutes."
send_notify "Time's up!" "Clean up your mess! Lockout active for $LOCKOUT_DURATION minutes."

# 5. Schedule the Ender (Stops the Enforcer after $LOCKOUT_DURATION)
CMD_STOP="systemctl --user stop ${UNIT_ENFORCER}.timer && \
          notify-send -i '$ICON' 'Lockdown ended' 'You can resume your game(s) now.'"

systemd-run --user \
    --unit="$UNIT_ENDER" \
    --on-active="${LOCKOUT_DURATION}m" \
    sh -c "$CMD_STOP"
