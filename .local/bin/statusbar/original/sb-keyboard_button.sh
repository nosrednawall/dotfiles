#!/bin/bash

layout=$(setxkbmap -query | grep layout | awk '{print$2}' | grep 'br' -ic)
case $BLOCK_BUTTON in
    1)
        if [ $layout -eq 1 ];
        then
            setxkbmap -model pc105 -layout us -variant  altgr-intl
            notify-send -t 3000 "󰌌  Keyboard us" "Alterado o teclado para o layout americano" --icon="/usr/share/icons/ePapirus/16x16/devices/keyboard.svg"
        else
            setxkbmap -model pc105 -layout br -variant abnt2
            notify-send -t 3000 "󰌌 Keyboard br-abnt2" "Alterado o teclado para o layout Brasileiro" --icon="/usr/share/icons/ePapirus/16x16/devices/keyboard.svg"
        fi
        ;;
    8) emacsclient -c "$0" ;;

esac
