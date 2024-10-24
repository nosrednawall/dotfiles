#!/bin/bash
brilho=$(brightnessctl | awk '/%/ {print$4}' | cut -c 2-4 | sed 's/%//' | sed 's/)//')
brilhoIcone="^c#268bd2^󰃠 ^c#93a1a1^$brilho󰏰"

case "$BUTTON" in
    4) brightnessctl set 5%+ > /dev/null ;;
    5) brightnessctl set 5%- > /dev/null ;;
    8) emacsclient -c "$0" ;;
esac

echo "$brilhoIcone"
