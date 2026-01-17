#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/phrases"
FONT="Delta Corps Priest 1"

mkdir -p "$OUTPUT_DIR"

# Remaining names from strings.txt (lines 6-76)
names=(
    "Applepie"
    "Drop It Like Its Hot"
    "Localhost with the Most"
    "Sir Computes Alot"
    "Desktop Biohazard"
    "Error 404 Name Not Found"
    "HAL 9000"
    "R2 D2"
    "TARDIS"
    "Skynet"
    "JARVIS"
    "Potato"
    "Hot Pocket"
    "Spaghetti Code"
    "Taco Truck"
    "Bagel Logic"
    "Leftover Pizza"
    "Sourdough"
    "Espresso"
    "Burrito"
    "Stinky Tofu"
    "It Works on My Machine"
    "The Brick"
    "Money Pit"
    "Dust Magnet"
    "Not a Virus"
    "Still Compiling"
    "Kernel Panic"
    "Works on Paper"
    "Over Engineered"
    "Load Bearing Wallpaper"
    "Sudo Make Me a Sandwich"
    "Space Heater"
    "FBI Surveillance Van"
    "It Worked Yesterday"
    "Experimental Build"
    "Held Together by Hope"
    "Overclocked Calculator"
    "Glorified Typewritter"
    "I Use Arch BTW"
    "Undefined Behavior"
    "Syntax Error"
    "Dependency Hell"
    "Not Responding"
    "Temporary Fix"
    "Dumpster Fire"
    "Nuclear Fusion"
    "Jerry Rigged"
    "Did You Try Turning It on and off Again"
    "Feature Creep"
    "Abadonware"
    "Technical Debt Collector"
    "Unstable Branch"
    "Stuck in Vim"
    "ANSI Escape Room"
    "Mouse Is Bloat"
    "512K RAM"
    "Look Ma No Mouse"
    "Buttons Sold Separately"
    "Vowels Are Extra"
    "Piped to Null"
    "Grep My Sanity"
    "Sh Happens"
    "Ncurses and Cursing"
    "Glyph Hanger"
    "TUI Much Info"
    "GPU Accelerated Text File"
    "Expensive ASCII Art"
    "Eye Candy"
    "Tiling and Toiling"
    "Cheese Grater"
)

# Split a phrase into lines with max 2 words each
split_phrase() {
    local phrase="$1"
    local -a words
    read -ra words <<< "$phrase"
    local count=${#words[@]}
    
    if [ "$count" -le 2 ]; then
        echo "$phrase"
        return
    fi
    
    # Split into chunks of 2 words
    local i=0
    while [ "$i" -lt "$count" ]; do
        if [ "$((i + 1))" -lt "$count" ]; then
            echo "${words[$i]} ${words[$((i + 1))]}"
            i=$((i + 2))
        else
            echo "${words[$i]}"
            i=$((i + 1))
        fi
    done
}

for name in "${names[@]}"; do
    # Convert to lowercase filename with spaces as underscores
    filename=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    output_file="${OUTPUT_DIR}/${filename}.txt"
    
    echo "Generating: ${filename}.txt"
    
    # Count words
    word_count=$(echo "$name" | wc -w)
    
    if [ "$word_count" -le 2 ]; then
        # Single line for 1-2 words
        figlet -f "$FONT" "$name" > "$output_file"
    else
        # Multi-line for 3+ words
        > "$output_file"
        while IFS= read -r line; do
            figlet -f "$FONT" "$line" >> "$output_file"
            echo >> "$output_file"
        done < <(split_phrase "$name")
    fi
done

echo "Done! Generated ${#names[@]} files."
