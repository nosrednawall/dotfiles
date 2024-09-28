#!/bin/sh
# Display volume levels.
#
case "$BUTTON" in
    1) setsid --fork st -e pulsemixer ;;
    3) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    8) emacsclient -c "$0" ;;
esac

muteVol=$(pactl get-sink-mute @DEFAULT_SINK@ | grep "sim" -ic)
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume" | awk '{print$5}' | sed 's/%//')

if [ "$muteVol" -eq 1 ]; then
    iconVolume="^c#4A5947^󰸈 $volume󰏰"
else
    if [ "$volume" -le 30 ]; then
	iconVolume="^c#859900^󰕿 ^c#93a1a1^$volume󰏰"
    elif [ "$volume" -le 60 ]; then
	iconVolume="^c#859900^󰖀 ^c#93a1a1^$volume󰏰"
    elif [ "$volume" -ge 61 ]; then
	iconVolume="^c#859900^󰕾 ^c#93a1a1^$volume󰏰"
    fi
fi

echo "$iconVolume"
