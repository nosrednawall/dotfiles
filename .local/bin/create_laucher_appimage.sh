#!/bin/bash

# Função para criar o lançador
create_launcher() {
    local appimage_path="$1"
    local app_name="$2"
    local app_icon_path="$3"

    # Diretório onde o arquivo .desktop será criado
    local desktop_dir="$HOME/.local/share/applications"
    mkdir -p "$desktop_dir"

    # Conteúdo do arquivo .desktop
    local desktop_file_content="[Desktop Entry]
Type=Application
Name=${app_name}
Exec=${appimage_path}
Icon=${app_icon_path}
Terminal=false
Categories=Utility;"

    # Caminho completo do arquivo .desktop
    local desktop_file_path="${desktop_dir}/${app_name}.desktop"

    # Criação do arquivo .desktop
    echo "$desktop_file_content" > "$desktop_file_path"

    # Tornar o arquivo .desktop executável
    chmod +x "$desktop_file_path"

    echo "Lançador criado em: ${desktop_file_path}"
}

# Verificação dos argumentos
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 caminho_para_appimage nome_do_app caminho_para_icone"
    exit 1
fi

# Chamando a função para criar o lançador
create_launcher "$1" "$2" "$3"
