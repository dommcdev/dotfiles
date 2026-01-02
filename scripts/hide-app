#!/usr/bin/env bash

# Define the absolute path to your dotfiles repo
HIDDEN_DIR="$HOME/dev/dotfiles/apps/desktop-files/hidden"
DOTFILES_ROOT="$HOME/dev/dotfiles"

# 1. Ask for the application name
read -p "Enter the Name of the app to hide (e.g., Remote Viewer): " search_name

if [[ -z "$search_name" ]]; then
    echo "No name entered. Exiting."
    exit 1
fi

# 2. Find the .desktop file in /usr/share/applications
# We look for the exact Name field (case-insensitive)
system_path=$(grep -ril "^Name=$search_name$" /usr/share/applications | head -n 1)

if [[ -z "$system_path" ]]; then
    echo "Could not find an exact system match for Name=$search_name"
    echo "Showing partial matches in /usr/share/applications/:"
    grep -ri "^Name=.*$search_name" /usr/share/applications | head -n 5
    exit 1
fi

# 3. Get the filename (e.g., remote-viewer.desktop)
target_filename=$(basename "$system_path")
echo "Found system match: $target_filename"

# 5. Create the override file in the specific dotfiles folder
cat << ENTR > "$HIDDEN_DIR/$target_filename"
[Desktop Entry]
Type=Application
Name=$search_name
NoDisplay=true
ENTR

echo "Successfully created override in $HIDDEN_DIR/$target_filename"

# 6. Run your dotfiles installer
echo "Applying dotfiles..."
cd "$DOTFILES_ROOT" && ./setup linux-desktop/apps
