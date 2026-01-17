#!/usr/bin/env bash
set -euo pipefail

# Fonts
FONT_NO_NUMBERS="Delta Corps Priest 1"
FONT_WITH_NUMBERS="DOS Rebel"

# Target ~11 chars per line
TARGET_LINE_WIDTH=11

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

# Split phrase into balanced lines of ~11 chars each, never breaking words
# Algorithm: look-ahead to decide if breaking now or later gives more balanced lines
split_phrase() {
    local phrase="$1"
    local -a words
    read -ra words <<< "$phrase"
    local word_count=${#words[@]}

    # Single word or empty - just return as-is
    if [ "$word_count" -le 1 ]; then
        echo "$phrase"
        return
    fi

    # Calculate total character length (including spaces between words)
    local total_len=0
    for word in "${words[@]}"; do
        total_len=$((total_len + ${#word}))
    done
    total_len=$((total_len + word_count - 1))  # Add spaces

    # Determine number of lines needed (round up)
    local num_lines=$(( (total_len + TARGET_LINE_WIDTH - 1) / TARGET_LINE_WIDTH ))
    [ "$num_lines" -lt 1 ] && num_lines=1
    [ "$num_lines" -gt "$word_count" ] && num_lines=$word_count

    # If everything fits on one line, just return it
    if [ "$num_lines" -eq 1 ]; then
        echo "$phrase"
        return
    fi

    # Calculate remaining chars from a given word index to the end
    local -a suffix_lens
    suffix_lens[$word_count]=0
    for ((i = word_count - 1; i >= 0; i--)); do
        local wlen=${#words[$i]}
        if [ $i -eq $((word_count - 1)) ]; then
            suffix_lens[$i]=$wlen
        else
            suffix_lens[$i]=$((wlen + 1 + suffix_lens[$((i + 1))]))
        fi
    done

    # Distribute words across lines using look-ahead
    local current_line=""
    local current_len=0
    local lines_remaining=$num_lines
    local word_idx=0

    for word in "${words[@]}"; do
        local word_len=${#word}

        if [ -z "$current_line" ]; then
            # First word on line
            current_line="$word"
            current_len=$word_len
        else
            # Calculate what happens if we break NOW vs add this word
            local len_if_add=$((current_len + 1 + word_len))
            local remaining_after=${suffix_lens[$((word_idx + 1))]:-0}

            # If this is the last line, just add the word
            if [ "$lines_remaining" -le 1 ]; then
                current_line="$current_line $word"
                current_len=$len_if_add
            else
                # Compare balance: break now vs continue
                # Option A: break now -> current line = current_len, rest gets remaining chars
                # Option B: add word -> current line = len_if_add, rest gets remaining_after
                local rest_if_break=$((current_len + 1 + word_len + remaining_after))
                rest_if_break=$((rest_if_break - current_len))  # chars left for other lines
                local rest_if_add=$remaining_after

                # Calculate average for remaining lines in each scenario
                local avg_if_break=$(( (current_len + rest_if_break / (lines_remaining)) / 2 ))
                local avg_if_add=$(( (len_if_add + rest_if_add / (lines_remaining - 1 > 0 ? lines_remaining - 1 : 1)) / 2 ))

                # Simpler: compare deviation from ideal balanced length
                local target=$((total_len / num_lines))
                local dev_break=${current_len#-}
                dev_break=$((current_len - target))
                [ $dev_break -lt 0 ] && dev_break=$((-dev_break))
                local dev_add=$((len_if_add - target))
                [ $dev_add -lt 0 ] && dev_add=$((-dev_add))

                # Break if current line is closer to target than adding would be
                # AND we have remaining lines to use
                if [ "$lines_remaining" -gt 1 ] && [ "$dev_break" -le "$dev_add" ]; then
                    echo "$current_line"
                    lines_remaining=$((lines_remaining - 1))
                    current_line="$word"
                    current_len=$word_len
                else
                    current_line="$current_line $word"
                    current_len=$len_if_add
                fi
            fi
        fi
        word_idx=$((word_idx + 1))
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
