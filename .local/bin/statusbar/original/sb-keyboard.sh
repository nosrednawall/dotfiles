#!/bin/bash

layout=$(setxkbmap -query | grep layout | awk '{print$2}' | grep 'br' -ic)
layout_atual="^d^^c#2aa198^󰌌 ^d^^c#93a1a1^$(setxkbmap -query | grep layout | awk '{print$2}')^c#2aa198^"

case $BUTTON in
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

# Verifique o estado atual do Caps Lock
CAPS_STATE=$(xset q | grep "Caps Lock:" | awk '{print $4}')

if [ "$CAPS_STATE" == "on" ]; then
    caps="󰪛"
else
    caps=""
fi

# Verificar o estado atual do Num Lock
NUMLOCK_STATE=$(xset q | grep "Num Lock:" | awk '{print $8}')

if [ "$NUMLOCK_STATE" == "on" ]; then
    num="󰎠"
else
    num=""
fi

# Logica para visualizacao
if [[ ! -z "$caps" ]] then
   if [[ ! -z "$num" ]] then
      echo "$layout_atual $caps $num"
   else
       echo "$layout_atual $caps"
   fi
else
   if [[ ! -z "$num" ]] then
      echo "$layout_atual $num"
   else
       echo "$layout_atual"
   fi
fi
