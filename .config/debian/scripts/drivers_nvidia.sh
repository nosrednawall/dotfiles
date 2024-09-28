#!/bin/bash

# Driver Nvidia
sudo apt install -y dkms linux-headers-amd64 firmware-misc-nonfree
sudo apt install -y nvidia-driver nvidia-xconfig xserver-xorg-video-amdgpu nvidia-cuda-dev nvidia-cuda-toolkit libnvidia-encode1
# sudo reboot
sudo nvidia-xconfig --prime

echo "Reboot necessário..."
