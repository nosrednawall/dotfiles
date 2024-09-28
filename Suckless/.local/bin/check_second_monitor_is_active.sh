#!/bin/bash
monitor=$(xrandr | grep "HDMI-0 connected" -ci | cut -c 1-16 )

if [ $monitor -eq 1  ]
then
	xrandr --output HDMI-0 --auto --rotate normal --dpi 96 --rate 60 --output eDP-1-1 --primary --mode 1920x1080 --rotate normal --left-of HDMI-0 --dpi 96 --rate 60
else
	xrandr --output eDP-1-1 --primary --mode 1920x1080 --rotate normal --dpi 96 --rate 60
fi
