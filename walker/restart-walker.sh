#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
  echo "Error: Do not run this script as root" >&2
  exit 1
fi

if systemctl --user is-enabled elephant.service &>/dev/null; then
  systemctl --user restart elephant.service
fi

pkill walker
walker --gapplication-service &
