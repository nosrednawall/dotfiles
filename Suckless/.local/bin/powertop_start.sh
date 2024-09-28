#!/bin/bash

powertop --auto-tune
sleep 5

# Restaurar configuração de dispositivos USB
for DEV in /sys/bus/usb/devices/*/power/control; do
    echo on > $DEV
done
