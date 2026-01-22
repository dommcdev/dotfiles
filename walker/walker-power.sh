#!/usr/bin/env bash

menu() {
  local prompt="$1"
  local options="$2"

  # walker dmenu mode
  echo -e "$options" | walker --dmenu --width 295 -p "$prompt"
}

show_system_menu() {
  # Removed trailing newline to prevent empty extra item
  local options="󰐥  Shutdown\n󰜉  Reboot\n󰒲  Suspend\n󰍃  Log Out\n  Lock\n󱄄  Screensaver\n󱄄  Lava Lamp\n󰜉  Reboot to UEFI"

  case $(menu "System" "$options") in
  *Shutdown*) systemctl poweroff ;;
  *Reboot*) systemctl reboot ;;
  *Suspend*) systemctl suspend ;;
  *Logout*) uwsm stop ;;
  *Lock*) loginctl lock-session ;;
  *Screensaver*) launch-screensaver.sh ;;
  *Lava*Lamp*) launch-screensaver.sh -l ;;
  *Reboot*UEFI*) systemctl reboot --firmware-setup ;;
  esac
}

show_system_menu
