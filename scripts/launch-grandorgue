#!/usr/bin/env bash

# ---------------------------------------------------------------------------- #
#   Launch Grandorgue
# ---------------------------------------------------------------------------- #
if flatpak ps | grep -q "net.sourceforge.GrandOrgue"; then
    flatpak kill net.sourceforge.GrandOrgue
    while flatpak ps | grep -q "net.sourceforge.GrandOrgue"; do sleep 0.2; done
fi
flatpak run --env=PIPEWIRE_LATENCY="128/48000" net.sourceforge.GrandOrgue -c ~/.config/GrandOrgueConfig &
#PIPEWIRE_LATENCY="128/48000" GrandOrgue -c ~/.config/GrandOrgueConfig &

# ---------------------------------------------------------------------------- #
#   Route audio
# ---------------------------------------------------------------------------- #
DEFAULT_SINK=$(pactl get-default-sink)
echo "Routing GrandOrgue to: $DEFAULT_SINK"

for i in {1..60}; do
    if pw-link -o | grep -q "GrandOrgueAudio:out_0" && \
       pw-link -o | grep -q "GrandOrgueAudio:out_1"; then
        break
    fi
    sleep 0.25
done

# Connect Left Channel (out_0 -> playback_FL or playback_1)
pw-link "GrandOrgueAudio:out_0" "${DEFAULT_SINK}:playback_FL" 2>/dev/null || \
pw-link "GrandOrgueAudio:out_0" "${DEFAULT_SINK}:playback_1" 2>/dev/null

# Connect Right Channel (out_1 -> playback_FR or playback_2)
pw-link "GrandOrgueAudio:out_1" "${DEFAULT_SINK}:playback_FR" 2>/dev/null || \
pw-link "GrandOrgueAudio:out_1" "${DEFAULT_SINK}:playback_2" 2>/dev/null
