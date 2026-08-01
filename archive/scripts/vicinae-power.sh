#!/usr/bin/env bash

menu() {
  local prompt="$1"
  local options="$2"

  echo -e "$options" | vicinae dmenu -p "$prompt" --no-section --no-quick-look --no-metadata --no-footer -W 270 -H 320
}

show_system_menu() {
  # Spacer to push aliases off-screen (requires item_dmenu.xml with ellipsize=0)
  local s="                                                                                "

  local options="󰐥  Shutdown\n󰜉  Reboot\n󰒲  Suspend\n󰍃  Log Out\n  Lock\n󱄄  Screensaver\n󰟕  Lava Lamp\n󰜉  Reboot to UEFI"

  case $(menu "Power menu" "$options") in
    *Shutdown*)     systemctl poweroff ;;
    *Reboot*UEFI*)  systemctl reboot --firmware-setup ;;
    *Reboot*)       systemctl reboot ;;
    *Suspend*)      systemctl suspend ;;
    *Logout*)       uwsm stop ;;
    *Lock*)         loginctl lock-session ;;
    *Screensaver*)  launch-screensaver.sh ;;
    *Lava*Lamp*)    launch-screensaver.sh -l ;;
  esac
}

show_system_menu
