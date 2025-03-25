#!/bin/bash

# Obter a lista de monitores conectados
monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)

# Função para listar resoluções suportadas por um monitor
list_resolutions() {
    local monitor=$1
    xrandr --query | grep -A1 "^$monitor" | tail -n1 | sed 's/ \+/ /g' | cut -d" " -f4- | tr ',' '\n' | grep -v '^$'
}

# Inicializar variáveis para armazenar a menor resolução comum
min_width=9999
min_height=9999

# Verificar se há monitores conectados
if [ -z "$monitors" ]; then
    echo "Nenhum monitor conectado foi detectado."
    exit 1
fi

# Obter todas as resoluções suportadas pelo primeiro monitor
common_resolutions=$(list_resolutions $(echo $monitors | cut -d" " -f1))

# Iterar sobre as resoluções do primeiro monitor e verificar se são suportadas pelos outros
for resolution in $common_resolutions; do
    width=$(echo $resolution | cut -d"x" -f1)
    height=$(echo $resolution | cut -d"x" -f2)

    # Verificar se a resolução é suportada por todos os monitores
    all_support=true
    for monitor in $monitors; do
        if ! list_resolutions $monitor | grep -q "^${width}x${height}$"; then
            all_support=false
            break
        fi
    done

    # Se for suportada por todos, verificar se é a menor
    if $all_support && ([ $width -lt $min_width ] || ([ $width -eq $min_width ] && [ $height -lt $min_height ])); then
        min_width=$width
        min_height=$height
    fi
done

# Verificar se uma resolução comum foi encontrada
if [ $min_width -eq 9999 ] || [ $min_height -eq 9999 ]; then
    echo "Nenhuma resolução comum foi encontrada entre os monitores."
    exit 1
fi

# Ajustar a resolução de todos os monitores para a menor resolução comum
for monitor in $monitors; do
    xrandr --output $monitor --mode ${min_width}x${min_height}
done

echo "Todos os monitores foram ajustados para a resolução comum ${min_width}x${min_height}."
