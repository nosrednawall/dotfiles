#!/bin/sh

case "$BLOCK_BUTTON" in
    1) notify "$(acpi -b | awk -F ': |, ' '{printf "%s\n%s\n", $2, $4}')" ;;
    8) st -e emacsclient -c "$0" ;;
esac
