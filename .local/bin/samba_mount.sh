#!/bin/bash

# Definindo variáveis de autenticação
SERVER="192.168.42.999"
USERNAME="tralala"
PASSWORD=$(pass samba-local)
WORKGROUP="trlala"
MOUNTPOINT="/mnt"

# Definindo as partições
SHARES=("HD-1-TERA" "HD-4-TERAS" "HD-500-GIGAS")

# Loop para montar as partições
for SHARE in "${SHARES[@]}"; do
    # Diretório de montagem
    MOUNT_DIR="${MOUNTPOINT}/${SHARE}"

    # Criar diretório de montagem caso não exista
    mkdir -p "$MOUNT_DIR"

    # Montar a partição
    mount -t cifs //"${SERVER}/${SHARE}" "$MOUNT_DIR" \
    -o username="$USERNAME",password="$PASSWORD",workgroup="$WORKGROUP",iocharset=utf8,uid="$USERNAME",gid="$USERNAME"

    # Verificar se a montagem foi bem-sucedida
    if mount | grep "$MOUNT_DIR" > /dev/null; then
        echo "Partição ${SHARE} montada com sucesso em ${MOUNT_DIR}"
    else
        echo "Falha ao montar ${SHARE} em ${MOUNT_DIR}"
    fi
done
