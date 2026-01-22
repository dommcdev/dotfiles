#!/usr/bin/env bash

menu() {
  local prompt="$1"
  local options="$2"

  echo -e "$options" | walker --dmenu --width 265 --minwidth 265 --maxwidth 265 --height 300 --minheight 300 --maxheight 300 -p "$prompt"
}

show_system_menu() {
  # Spacer to push aliases off-screen (requires item_dmenu.xml with ellipsize=0)
  local s="                                                                                                    "

  local options="󰐥  Shutdown${s}power off\n󰜉  Reboot${s}restart\n󰒲  Suspend${s}sleep\n󰍃  Log Out${s}logout\n  Lock\n󱄄  Screensaver\n󱄄  Lava Lamp\n󰜉  Reboot to UEFI${s}bios"

  case $(menu "System" "$options") in
  *Shutdown*) systemctl poweroff ;;
  *Reboot*UEFI*) systemctl reboot --firmware-setup ;;
  *Reboot*) systemctl reboot ;;
  *Suspend*) systemctl suspend ;;
  *Logout*) uwsm stop ;;
  *Lock*) loginctl lock-session ;;
  *Screensaver*) launch-screensaver.sh ;;
  *Lava*Lamp*) launch-screensaver.sh -l ;;
  esac
}

show_system_menu
