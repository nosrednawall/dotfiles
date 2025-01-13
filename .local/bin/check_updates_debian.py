#!/bin/sh

updates=$(apt list --upgradable 2>/dev/null | grep -c 'upgradable')

if [ "$updates" -eq 0 ]; then
    echo "0"
else
    echo "$updates updates"
fi
