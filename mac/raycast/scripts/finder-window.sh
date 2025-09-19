#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Finder Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

osascript -e 'tell application "Finder" to make new Finder window to (path to home folder)' >/dev/null
