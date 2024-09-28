#!/bin/bash

# Gerenciador de sessao
sudo apt install -y lightdm  lightdm-gtk-greeter

escolha_notebook_acer() {
    local wm_name="$1"
    echo "$wm_name é um notebook da acer?"
    echo "1. Instalar $wm_name com script para configurar tela de login no laptop"
    echo "Ou ENTER para pular"
    read -r choice

   case "$choice" in
        1)
            # Configurar o lightdm para abrir apenas no monitor do notebook
sudo cat > /usr/share/multiple-monitors.sh << EOF
#!/bin/bash
xrandr --output  HDMI-0 --off --output eDP-1-1 --primary --mode 1920x1080 --rotate normal --dpi 96
EOF

            sudo chmod +x /usr/share/multiple-monitors.sh
            sudo sed -i 's|^\#display-setup-script=|display-setup-script=/usr/share/multiple-monitors.sh|' /etc/lightdm/lightdm.conf
            ;;
        *)
            echo "Pulando essa etapa, e instalando o resto..."
            ;;
    esac

    # Adding a couple of line returns
    echo -e "\n\n"
}
escolha_notebook_acer
