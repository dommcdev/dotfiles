#!/usr/bin/env bash

pause_and_continue() {
    echo ""
    read -rp "Press enter to continue... "
}

sign_in_google() {
    read -rp "Would you like to sign in to your Google account? [Y/n] "
    if [[ "${REPLY,,}" =~ ^y$|^$ ]]; then
        xdg-open https://accounts.google.com
        pause_and_continue
    fi
}

start_tailscale() {
    read -rp "Would you like to start tailscale? [Y/n] "
    if [[ "${REPLY,,}" =~ ^y$|^$ ]]; then
        tailscale up
        pause_and_continue
    fi
}

setup_gitrepos() {
    read -rp "Would you like to authenticate git and clone repos? [Y/n] "
    if [[ "${REPLY,,}" =~ ^y$|^$ ]]; then
        bash ~/dev/dotfiles/setup dev/gitrepos
        pause_and_continue
    fi
}

enroll_fingerprints() {
    read -rp "Would you like to enroll fingerprints? [Y/n] "
    if [[ "${REPLY,,}" =~ ^y$|^$ ]]; then
        bash ~/.local/bin/enroll-fingerprints
        pause_and_continue
    fi
}

timeshift_setup() {
    read -rp "Would you like to set up Timeshift (choose disk for snapshots)? [Y/n] "
    if [[ "${REPLY,,}" =~ ^y$|^$ ]]; then
        timeshift-gtk &
        pause_and_continue
    fi
}

sign_in_google
start_tailscale
setup_gitrepos
enroll_fingerprints
timeshift_setup
# Set up chrome stuff - don't show cards/shortcuts, set wallpaper
