#!/usr/bin/env bash

set -euo pipefail

default_location="$HOME/dev/projects"

# Format: "repo|location". Leave location empty to use the default above.
repos=(
  "portfolio|"
  "courses|$HOME/dev/"
  "homelab|$HOME/dev/"
  "beans|$HOME/dev/"
  "chopchop|"
)

for entry in "${repos[@]}"; do
  IFS='|' read -r repo location <<< "$entry"
  location="${location:-$default_location}"

  mkdir -p "$location"
  if git -C "$location/$repo" rev-parse --git-dir > /dev/null 2>&1; then
    echo "Skipping $repo: already cloned at $location/$repo"
    continue
  fi

  git clone "https://github.com/dommcdev/${repo}.git" "$location/$repo"
done
