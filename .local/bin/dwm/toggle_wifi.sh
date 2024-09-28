#!/usr/bin/env sh

status=$(nmcli radio wifi | grep "enabled" -ic)

if [ $status -eq 1 ]; then
    nmcli radio wifi off
    notify-send -t 3000 "Wifi Off" "Placa wifi desligada" --icon="/usr/share/icons/ePapirus/16x16/actions/brightnesssettings.svg"

else
    nmcli radio wifi on
    notify-send -t 3000 "Wifi On" "Placa wifi ligada" --icon="/usr/share/icons/ePapirus/16x16/actions/brightnesssettings.svg"
fi
