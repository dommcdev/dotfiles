#!/usr/bin/env bash
set -euo pipefail

# Fonts
FONT_NO_NUMBERS="Delta Corps Priest 1"
FONT_WITH_NUMBERS="DOS Rebel"

# Target ~11 chars per line, max 16 to allow flexibility
MAX_LINE_WIDTH=16

usage() {
    echo "Usage: $0 [-f file.txt] [phrase...]"
    echo ""
    echo "Options:"
    echo "  -f file.txt  Read phrases from file (one per line)"
    echo "  phrase...    One or more phrases to convert"
    echo "  (no args)    Interactive mode - prompts for input"
    echo ""
    echo "Output: Creates .tte files in current directory"
    echo "Font: Delta Corps Priest 1 (no numbers) or DOS Rebel (with numbers)"
    exit 0
}

# Check if phrase contains a number
has_number() {
    [[ "$1" =~ [0-9] ]]
}

# Split phrase into lines of ~11 chars, never breaking words
# Uses greedy algorithm: add words until next word would exceed MAX_LINE_WIDTH
split_phrase() {
    local phrase="$1"
    local -a words
    read -ra words <<< "$phrase"

    local current_line=""
    local current_len=0

    for word in "${words[@]}"; do
        local word_len=${#word}

        if [ -z "$current_line" ]; then
            # First word on line
            current_line="$word"
            current_len=$word_len
        elif [ $((current_len + 1 + word_len)) -le $MAX_LINE_WIDTH ]; then
            # Word fits on current line (including space)
            current_line="$current_line $word"
            current_len=$((current_len + 1 + word_len))
        else
            # Word doesn't fit, output current line and start new one
            echo "$current_line"
            current_line="$word"
            current_len=$word_len
        fi
    done

    # Output remaining line
    if [ -n "$current_line" ]; then
        echo "$current_line"
    fi
}

# Generate ASCII art for a single phrase
generate_ascii() {
    local phrase="$1"

    # Skip empty/whitespace-only lines
    [[ -z "${phrase// }" ]] && return

    # Determine filename: lowercase, spaces to underscores, remove special chars
    local filename
    filename=$(echo "$phrase" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd 'a-z0-9_')
    filename="${filename}.tte"

    # Select font based on whether phrase contains numbers
    local font
    if has_number "$phrase"; then
        font="$FONT_WITH_NUMBERS"
    else
        font="$FONT_NO_NUMBERS"
    fi

    echo "Generating: ${filename} (font: ${font})"

    # Generate ASCII art, one figlet call per line
    > "$filename"
    while IFS= read -r line; do
        figlet -f "$font" "$line" >> "$filename"
    done < <(split_phrase "$phrase")
}

main() {
    local file=""
    local -a phrases=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f)
                if [[ -z "${2:-}" ]]; then
                    echo "Error: -f requires a filename"
                    exit 1
                fi
                file="$2"
                shift 2
                ;;
            -h|--help)
                usage
                ;;
            *)
                phrases+=("$1")
                shift
                ;;
        esac
    done

    # Determine input source
    if [[ -n "$file" ]]; then
        # Read from file
        if [[ ! -f "$file" ]]; then
            echo "Error: File not found: $file"
            exit 1
        fi
        while IFS= read -r line || [[ -n "$line" ]]; do
            generate_ascii "$line"
        done < "$file"
    elif [[ ${#phrases[@]} -gt 0 ]]; then
        # Use command line arguments
        for phrase in "${phrases[@]}"; do
            generate_ascii "$phrase"
        done
    else
        # Interactive mode
        echo "Enter phrases (one per line, Ctrl+D when done):"
        while IFS= read -r line; do
            generate_ascii "$line"
        done
    fi

    echo "Done!"
}

main "$@"
