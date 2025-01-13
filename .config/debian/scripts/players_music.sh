#!/bin/bash
#
# Music - MPD inicio pelo systemctl para o usuario
sudo apt install -y playerctl mpd ncmpcpp mpc
sudo systemctl disable mpd
sudo systemctl stop  mpd
systemctl --user enable mpd
