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
eval "$(echo "$weather_json" | jq -r '
  .nearest_area[0] as $area |
  .current_condition[0] |
  "code=\(.weatherCode)
temp=\(.temp_F)
desc=\"\(.weatherDesc[0].value)\"
wind_speed=\(.windspeedMiles)
wind_dir=\(.winddir16Point)
precip=\(.precipInches)
city=\"\($area.areaName[0].value)\"
region=\"\($area.region[0].value)\"
country=\"\($area.country[0].value)\""
')"

icon=$(get_icon "$code")
timestamp=$(date '+%I:%M %p')

# Wind direction to arrow (arrow shows direction wind is blowing TO)
get_wind_arrow() {
    case $1 in
        N)   echo "↓" ;;
        NNE) echo "↓" ;;
        NE)  echo "↙" ;;
        ENE) echo "←" ;;
        E)   echo "←" ;;
        ESE) echo "←" ;;
        SE)  echo "↖" ;;
        SSE) echo "↑" ;;
        S)   echo "↑" ;;
        SSW) echo "↑" ;;
        SW)  echo "↗" ;;
        WSW) echo "→" ;;
        W)   echo "→" ;;
        WNW) echo "→" ;;
        NW)  echo "↘" ;;
        NNW) echo "↓" ;;
        *)   echo "" ;;
    esac
}

wind_arrow=$(get_wind_arrow "$wind_dir")

# Build tooltip
tooltip="${city}, ${region}
${desc}, ${temp}°F
${wind_arrow} ${wind_speed} mph, ${precip} in
${timestamp}"

# Escape tooltip for JSON
tooltip_escaped=$(printf '%s' "$tooltip" | jq -Rs .)

# Print JSON for Waybar
printf '{"text": "%s %s°F", "tooltip": %s, "class": "weather"}\n' "$icon" "$temp" "$tooltip_escaped"
