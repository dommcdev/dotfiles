if [[ "$(sys id)" == "fedora-asahi-remix" ]]; then
    flatpak run org.chromium.Chromium --password-store=kwallet5
else
    google-chrome-stable
fi
