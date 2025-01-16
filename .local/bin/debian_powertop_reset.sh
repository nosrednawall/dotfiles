#!/bin/bash

# Restaurar configurações de dispositivo
for DEV in /sys/class/scsi_host/host*/link_power_management_policy; do
    echo max_performance > $DEV
done

for DEV in /sys/class/scsi_disk/*/power_management; do
    echo on > $DEV
done

for DEV in /sys/class/sas_phy/phy*/minimum_linkrate; do
    echo 1.5 Gbps > $DEV
done

for DEV in /sys/class/net/*/device/power/control; do
    echo on > $DEV
done

# Restaurar configuração de dispositivos USB
for DEV in /sys/bus/usb/devices/*/power/control; do
    echo on > $DEV
done

# Restaurar configuração de dispositivos PCIe
for DEV in /sys/bus/pci/devices/*/power/control; do
    echo on > $DEV
done

# Restaurar configuração do scheduler
echo noop > /sys/block/sda/queue/scheduler

# Desabilitar USB autosuspend
echo -1 > /sys/module/usbcore/parameters/autosuspend

# Reiniciar serviços para aplicar mudanças
systemctl restart NetworkManager.service
systemctl restart bluetooth.service

echo "Configurações de energia restauradas para os valores padrões."
