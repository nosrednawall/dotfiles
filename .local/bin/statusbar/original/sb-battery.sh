#!/bin/sh
# Display the current battery status.

notify() {
    notify-send \
        --icon=battery-good-symbolic \
        --expire-time=4000 \
        --hint=string:x-canonical-private-synchronous:battery \
        "Battery" "$1"
}

case "$BUTTON" in
    1) notify "$(acpi -b | awk -F ': |, ' '{printf "%s\n%s\n", $2, $4}')" ;;
    8) st -e emacsclient -c "$0" ;;
esac


# Loop through all attached batteries.
for battery in /sys/class/power_supply/BAT?*; do
    # If non-first battery, print a space separator.
    [ -n "${capacity+x}" ] && printf " "

    capacity="$(cat "$battery/capacity" 2>&1)"
    if [ "$capacity" -gt 90 ]; then
        status="^c#2aa198^ "
    elif [ "$capacity" -gt 60 ]; then
        status="^c#2aa198^ "
    elif [ "$capacity" -gt 40 ]; then
        status="^c#b58900^ "
    elif [ "$capacity" -gt 10 ]; then
        status="^c#cb4b16^ "
    else
        status="^c#dc322f^ "
    fi

    case "$(cat "$battery/status" 2>&1)" in
        Full) status="^c#2aa198^ " ;;
        Discharging)
            if [ "$capacity" -le 20 ]; then
                status="$status"
                color=1
            fi
            ;;
        Charging) status="󰚥$status" ;;
        "Not charging") status=" " ;;
        Unknown) status="? $status" ;;
        *) exit 1 ;;
    esac
    echo "$status^c#93a1a1^$capacity󰏰"
    #if [ "$capacity" -le 95 ]; then
    #    echo "$status^c#93a1a1^$capacity%  "
    #else
    #    echo ""
    #fi
done
