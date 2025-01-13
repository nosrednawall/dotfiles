#!/bin/sh
# Display volume levels.
#
case "$BLOCK_BUTTON" in
    1) setsid --fork st -e pulsemixer ;;
    3) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    8) emacsclient -c "$0" ;;
esac
