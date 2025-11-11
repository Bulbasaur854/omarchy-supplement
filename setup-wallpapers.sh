#!/bin/sh

# Kill all swaybg processes and discards any error messages
pkill -x swaybg 2>/dev/null
sleep 0.2

# Dynamic wallpaper setup
MONITORS=($(hyprctl monitors -j | jq -r '.[].name'))

if [ "${#MONITORS[@]}" -eq 1 ]; then
  uwsm app -- setsid swaybg \
    -o "${MONITORS[0]}" -i ~/.config/backgrounds/group_of_pink_flowers.jpg -m fill
else
  uwsm app -- setsid swaybg \
    -o "${MONITORS[0]}" -i ~/.config/backgrounds/astronaut_playing_a_piano.jpg -m fill \
    -o "${MONITORS[1]}" -i ~/.config/backgrounds/group_of_pink_flowers.jpg -m fill
fi

