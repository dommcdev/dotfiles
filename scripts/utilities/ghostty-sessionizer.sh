#!/usr/bin/env bash

# Define your paths with depth suffixes
SEARCH_PATHS=(
    ~/dev/dotfiles:1
    ~/dev/courses:2
    ~/dev/projects:1
    ~/dev/external:1
    ~/:1
    ~/dev:1
    ~/Downloads/Shared/Vault:1
)

if ! command -v fzf &>/dev/null; then
    echo "fzf is not installed. Please install it first." >&2
    exit 1
fi

find_dirs() {
    # Always put home dir first
    echo "$HOME"

    for entry in "${SEARCH_PATHS[@]}"; do
        if [[ "$entry" =~ ^([^:]+):([0-9]+)$ ]]; then
            path="${BASH_REMATCH[1]}"
            depth="${BASH_REMATCH[2]}"
        else
            path="$entry"
            depth=1
        fi

        # Expand tilde to absolute path
        path="${path/#\~/$HOME}"

        # Find directories, ignore .git, format with tilde for cleaner fzf UI
        if [[ -d "$path" ]]; then
            find "$path" -mindepth 1 -maxdepth "$depth" -path '*/.git' -prune -o -type d -print 2>/dev/null | sed -E "s|^$HOME|~|"
        fi
    done
}

# Allow passing a directory directly, otherwise launch fzf
if [[ -n "$1" ]]; then
    selected="$1"
else
    # The awk command removes duplicate paths just in case your search paths overlap
    selected=$(find_dirs | awk '!seen[$0]++' | fzf --prompt="Jump to: ")
    # Expand tilde back to absolute path for the final output
    selected="${selected/#\~/$HOME}"
fi

# If a valid selection was made, print it to stdout
if [[ -n "$selected" && -d "$selected" ]]; then
    echo "$selected"
fi
