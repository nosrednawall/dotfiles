#!/bin/bash

# IDE
sudo apt install -y emacs-gtk geany
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs

escolha_instalar_doom() {
    local wm_name="$1"
    echo "$wm_name Instalação"
    echo "1. Instalar doom agora"
    echo "Ou ENTER para pular"
    read -r choice

   case "$choice" in
        1)
            ~/.config/emacs/bin/doom install  # Cuidado para nao sobreescrever os arquivos do dotfiles
            ;;
        *)
            echo "Pulando essa etapa, e instalando o resto..."
            ;;
    esac

    # Adding a couple of line returns
    echo -e "\n\n"
}

escolha_instalar_doom
