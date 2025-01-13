#!/bin/bash
#
sudo apt install pipewire pipewire-pulse wireplumber pipewire-media-session pulsemixer
systemctl --user --now enable wireplumber.service
