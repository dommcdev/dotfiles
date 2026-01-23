#!/usr/bin/env bash

# Power button handling script with TUI popup
# Triggered when power button is pressed

set -e

# --- Colors & Styles ---
# Using standard ANSI colors from terminal theme
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Colors
C_ACCENT=$(tput setaf 4)    # Blue
C_DANGER=$(tput setaf 1)    # Red
C_DIM=$(tput setaf 8 2>/dev/null || tput setaf 0) # Gray/Black (fallback)
C_TEXT=$(tput setaf 7)      # White/Text

# Icons
ICON_SHUTDOWN="󰐥"
ICON_REBOOT="󰜉"
ICON_SUSPEND="󰒲"

# State
COUNTDOWN=15
SELECTED=2 # 0=Sleep, 1=Restart, 2=Shutdown (Default)

# Terminal geometry
ROWS=$(tput lines)
COLS=$(tput cols)

# --- System Actions ---

cleanup() {
    tput cnorm # Show cursor
    tput sgr0  # Reset colors
    clear
}

shutdown_system() {
    cleanup
    systemctl poweroff
    exit 0
}

reboot_system() {
    cleanup
    systemctl reboot
    exit 0
}

suspend_system() {
    cleanup
    systemctl suspend
    exit 0
}

# --- Drawing Logic ---

# Generate a single button box
# Returns 3 lines: top, middle, bottom
gen_button() {
    local label="$1"
    local icon="$2"
    local is_selected="$3"

    local text=" $icon $label "
    local len=${#text}

    local color_border="$C_DIM"
    local color_text="$C_DIM"

    if [[ "$is_selected" -eq 1 ]]; then
        color_border="$C_ACCENT"
        color_text="$C_ACCENT"
    fi

    # Horizontal border
    local h_border=""
    for ((i=0; i<len; i++)); do h_border+="─"; done

    # Return lines separated by newlines
    # Top
    echo "${color_border}╭${h_border}╮${RESET}"
    # Middle
    echo "${color_border}│${RESET}${color_text}${text}${RESET}${color_border}│${RESET}"
    # Bottom
    echo "${color_border}╰${h_border}╯${RESET}"
}

draw_frame() {
    # Move to top-left without clearing to prevent flicker
    tput cup 0 0

    # Prepare message
    local msg_plain="The system will shut down in $COUNTDOWN seconds."
    local msg_styled="${C_TEXT}The system will shut down in ${C_DANGER}${COUNTDOWN}${C_TEXT} seconds.${RESET}"

    # Calculate Vertical Padding (center vertically)
    # Content height:
    #   Text line
    #   Blank line
    #   Button top
    #   Button mid
    #   Button bot
    #   Blank line
    #   Help text
    # Total = 7 lines

    local content_height=7
    local pad_top=$(( (ROWS - content_height) / 2 ))
    [[ $pad_top -lt 0 ]] && pad_top=0

    # Print top padding
    for ((i=0; i<pad_top; i++)); do echo; done

    # 1. Print Message (Centered)
    local msg_len=${#msg_plain}
    local pad_msg=$(( (COLS - msg_len) / 2 ))
    [[ $pad_msg -lt 0 ]] && pad_msg=0
    printf "%*s%b\n\n" "$pad_msg" "" "$msg_styled"

    # 2. Prepare Buttons
    # We need to render them side-by-side

    # Capture output of gen_button
    # Use mapfile or read to split lines (bash specific)

    local b0_out b1_out b2_out
    b0_out=$(gen_button "Sleep" "$ICON_SUSPEND" "$((SELECTED == 0))")
    b1_out=$(gen_button "Restart" "$ICON_REBOOT" "$((SELECTED == 1))")
    b2_out=$(gen_button "Shutdown" "$ICON_SHUTDOWN" "$((SELECTED == 2))")

    # Split into arrays
    IFS=$'\n' read -d '' -r -a b0_lines <<< "$b0_out" || true
    IFS=$'\n' read -d '' -r -a b1_lines <<< "$b1_out" || true
    IFS=$'\n' read -d '' -r -a b2_lines <<< "$b2_out" || true

    # Calculate total width for centering
    # To get visible length, strip ANSI codes.
    # Hack: Assume standard padding.
    # Sleep: " 󰒲 Sleep " = 9 chars -> Box width 11
    # Restart: " 󰜉 Restart " = 11 chars -> Box width 13
    # Shutdown: " 󰐥 Shutdown " = 12 chars -> Box width 14
    # Spacing: 2 chars between buttons

    local w0=11
    local w1=13
    local w2=14
    local space=2
    local total_w=$((w0 + space + w1 + space + w2))

    local pad_btn=$(( (COLS - total_w) / 2 ))
    [[ $pad_btn -lt 0 ]] && pad_btn=0

    # Print the 3 rows of buttons
    printf "%*s%s  %s  %s\n" "$pad_btn" "" "${b0_lines[0]}" "${b1_lines[0]}" "${b2_lines[0]}"
    printf "%*s%s  %s  %s\n" "$pad_btn" "" "${b0_lines[1]}" "${b1_lines[1]}" "${b2_lines[1]}"
    printf "%*s%s  %s  %s\n" "$pad_btn" "" "${b0_lines[2]}" "${b1_lines[2]}" "${b2_lines[2]}"

    echo

    # 3. Help Text
    local help_txt="h/l navigate  ⏎ confirm  q cancel"
    local help_len=${#help_txt}
    local pad_help=$(( (COLS - help_len) / 2 ))
    [[ $pad_help -lt 0 ]] && pad_help=0

    printf "%*s${C_DIM}%s${RESET}\n" "$pad_help" "" "$help_txt"

    # Clear remaining lines to avoid artifacts if terminal resized
    tput ed
}

# --- Main Loop ---

run_tui() {
    tput civis # Hide cursor
    clear      # Initial clear

    trap cleanup EXIT INT TERM

    draw_frame

    while true; do
        # Wait for input with timeout (1s)
        if read -rsn1 -t 1 key; then
            # Handle Special Keys (Escape sequences)
            if [[ $key == $'\x1b' ]]; then
                read -rsn2 -t 0.01 seq || true
                if [[ -z $seq ]]; then
                    exit 0 # ESC
                fi
                case "$seq" in
                    '[D') key='h' ;;
                    '[C') key='l' ;;
                    *) continue ;;
                esac
            fi

            case "$key" in
                h|H) # Left
                    SELECTED=$((SELECTED - 1))
                    ((SELECTED < 0)) && SELECTED=2
                    ;;
                l|L) # Right
                    SELECTED=$((SELECTED + 1))
                    ((SELECTED > 2)) && SELECTED=0
                    ;;
                "") # Enter
                    case "$SELECTED" in
                        0) suspend_system ;;
                        1) reboot_system ;;
                        2) shutdown_system ;;
                    esac
                    ;;
                q|Q)
                    exit 0
                    ;;
            esac
            draw_frame
        else
            # Timeout - Countdown
            COUNTDOWN=$((COUNTDOWN - 1))
            if ((COUNTDOWN <= 0)); then
                shutdown_system
            fi
            draw_frame
        fi
    done
}

main() {
    run_tui
}

main "$@"
