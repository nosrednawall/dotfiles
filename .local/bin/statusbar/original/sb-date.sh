#!/bin/bash
# Display the current time in HH:MM:SS.

day=$(date "+%d")
image="/usr/share/icons/Numix/64/places/calendar-$day.svg"

case $BUTTON in
    1)
        notify-send -i "$image" " " "$(cal |  sed "s/..7m/<b><span color=\"#2aa198\">/;s/..27m/<\/span><\/b>/")"
        ;;
    6) emacsclient -c "$0" ;;
    3) setsid --fork st -e calcurse ;;

esac

echo "^c#2aa198^ ^c#93a1a1^$(date +'%d/%m/%Y')"
