#!/bin/bash

#Theme: Bleach

killall -q polybar

polybar bar1 -c ~/.config/polybar/config.ini | \
polybar bar2 -c ~/.config/polybar/config.ini | \
polybar bar3 -c ~/.config/polybar/config.ini | \
polybar bar4 -c ~/.config/polybar/config.ini | \
polybar bar5 -c ~/.config/polybar/config.ini | \
polybar bar6 -c ~/.config/polybar/config.ini 

