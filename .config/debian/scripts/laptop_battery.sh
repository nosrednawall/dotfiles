#!/bin/bash

# Bateria
sudo apt install -y xfce3-power-manager tlp
sudo systemctl disable powertop  # se o powertop estiver instalado, primeiro pare ele e depois desinstale
sudo systemctl enable --now tlp
# cp .config/systemd/user_gerados/xfce4-power-manager.service .config/systemd/user/
# systemctl --user enable xfce4-power-manager.service --now
