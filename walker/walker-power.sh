#!/usr/bin/env bash

# Power menu using Walker
# Adapted from omarchy-menu

menu() {
  local prompt="$1"
  local options="$2"

  # walker dmenu mode
  echo -e "$options" | walker --dmenu --width 295 --minheight 1 --maxheight 630 -p "$prompt"
}

show_system_menu() {
  local options="󰐥  Shutdown\n󰜉  Restart\n󰒲  Suspend\n  Lock\n󱄄  Screensaver\n󱄄  Lava Lamp\n"

  case $(menu "System" "$options") in
  *Lock*) loginctl lock-session ;;
  *Screensaver*) launch-screensaver.sh ;;
  *Lavalamp*) launch-screensaver.sh -l ;;
  *Suspend*) systemctl suspend ;;
  *Restart*) systemctl reboot ;;
  *Shutdown*) systemctl poweroff ;;
  esac
}

show_system_menu
