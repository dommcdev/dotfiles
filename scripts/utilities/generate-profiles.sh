#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$HOME/dev/dotfiles"
PROFILES_DIR="$ROOT_DIR/meta/profiles"
CONFIGS_DIR="$ROOT_DIR/meta/configs"

# Function to generate a single profile
# Usage: generate_profile "profile-name" "dir1" "dir2" ...
generate_profile() {
    local profile_name="$1"
    shift
    local dirs=("$@")
    local target_file="$PROFILES_DIR/$profile_name"
    
    echo "Generating $profile_name..."
    
    # Clear/Create file
    > "$target_file"
    
    for folder in "${dirs[@]}"; do
        local folder_path="$CONFIGS_DIR/$folder"
        
        if [[ -d "$folder_path" ]]; then
            # Use nullglob to handle empty directories
            shopt -s nullglob
            for yaml in "$folder_path"/*.yaml; do
                local base
                base=$(basename "$yaml" .yaml)
                echo "$folder/$base" >> "$target_file"
            done
            shopt -u nullglob
        else
            echo "  Warning: Config folder '$folder' not found"
        fi
    done
}

main() {
    # Server Profiles
    generate_profile "mac-server"    "all"
    generate_profile "arch-server"   "all" "arch" "linux"
    generate_profile "ubuntu-server" "all" "ubuntu" "linux"
    generate_profile "fedora-server" "all" "fedora" "linux"

    # DE Profiles (Server + GUI Essentials)
    generate_profile "mac-de"        "all" "desktop"
    generate_profile "arch-de"       "all" "arch" "linux" "linux-desktop" "desktop"
    generate_profile "ubuntu-de"     "all" "ubuntu" "linux" "linux-desktop" "desktop"
    generate_profile "fedora-de"     "all" "fedora" "linux" "linux-desktop" "desktop"

    # Custom Profiles (Full Rice)
    generate_profile "mac-custom"    "all" "mac" "desktop"
    generate_profile "arch-custom"   "all" "arch" "linux" "linux-desktop" "desktop" "custom"
    generate_profile "ubuntu-custom" "all" "ubuntu" "linux" "linux-desktop" "desktop" "custom"
    generate_profile "fedora-custom" "all" "fedora" "linux" "linux-desktop" "desktop" "custom"

    echo "Done. All profiles generated."
}

main
