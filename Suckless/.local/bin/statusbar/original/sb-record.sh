#!/bin/bash
# Display an indicator during screen records.
camera=$(fuser /dev/video* > /dev/null)

case "$BUTTON" in
    8) emacsclient -c "$0" ;;
esac

if [ -z "$camera" ]; then
    iconCam=""
else
    iconCam="^c#dc322f^ "
fi

echo "$iconCam"
