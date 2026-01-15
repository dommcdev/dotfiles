#!/bin/bash

CACHE_FILE="$HOME/.cache/waybar-weather.json"
mkdir -p "$(dirname "$CACHE_FILE")"

get_icon() {
    case $1 in
        113) echo "" ;;
        116) echo "" ;;
        119) echo "" ;;
        122) echo "" ;;
        143|248|260) echo "" ;;
        176|179|263|266|293|296|299|302|305|308|311|314|317|350|353|356|359|320) echo "" ;;
        200) echo "" ;;
        386|389|392|395) echo "" ;;
        227|230|323|326|329|332|335|338|368|371|374|377) echo "" ;;
        *) echo "" ;;
    esac
}

# Try to fetch weather
if weather_json=$(curl -s -f "https://wttr.in/?format=j1" --max-time 10); then
    # Success, save to cache
    echo "$weather_json" > "$CACHE_FILE"
else
    # Failed, try to load from cache
    if [ -f "$CACHE_FILE" ]; then
        weather_json=$(cat "$CACHE_FILE")
    else
        echo '{"text": "", "tooltip": "Weather unavailable"}'
        exit 1
    fi
fi

# Parse data using jq
# Extract code, temp, and description
eval "$(echo "$weather_json" | jq -r '.current_condition[0] | "code=\(.weatherCode)\ntemp=\(.temp_F)\ndesc=\"\(.weatherDesc[0].value)\""')"

icon=$(get_icon "$code")

# Print JSON for Waybar
# text: Icon + Temp
# tooltip: Description + Temp
# class: weather
printf '{"text": "%s %s°F", "tooltip": "%s %s°F", "class": "weather"}\n' "$icon" "$temp" "$desc" "$temp"
