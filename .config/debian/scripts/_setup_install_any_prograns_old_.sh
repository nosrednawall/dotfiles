#!/bin/bash

# Criacao de pastas
echo "Criando as pastas padroes"
mkdir -p /home/$USER/{Desktop,Downloads,Documentos,git,Imagens/Screenshoots,Músicas,.lyrics,.programas,.appimage}

# instala o git
echo "instalando git"
sudo apt install -y git aptitude htop pv lm-sensors stow xserver-xorg curl

# Instala o Oh My Bash
#cd ~
#bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
#rm .bashrc

# busca os dotfiles
#echo "Baixando os dotfiles - Lembrese de ativar o ssh depois"
#git clone https://github.com/nosrednawall/dotfiles.git ~/.dotfiles


# Drivers nvidia
install_drivers_nvidia() {
    echo "Instalando drivers nvidia"
    bash ~/.dotfiles/.config/debian/drivers_nvidia.sh
}

# Drivers amd
install_drivers_amd() {
    echo "Instalando drivers amd"
    bash ~/.dotfiles/.config/debian/drivers_amd.sh
}

# Drivers Intel
install_drivers_intel() {
    echo "Instalando drivers intel"
    bash ~/.dotfiles/.config/debian/drivers_intel.sh
}

# Funcao para o usuario escolher qual drive de vídeo quer instalar
escolha_driver() {
    local wm_name="$1"
    echo "$wm_name Instalação"
    echo "1. Instalar $wm_name com driver Nvdia"
    echo "2. Instalar $wm_name com driver Amd"
    echo "3. Instalar $wm_name com driver Intel"
    echo "Ou ENTER para pular"
    read -r choice

   case "$choice" in
        1)
            install_drivers_nvidia
            ;;
        2)
            install_driver_amd
            ;;
        3)
            install_driver_intel
            ;;
        *)
            echo "Pulando essa etapa, e instalando o resto..."
            ;;
    esac

    # Adding a couple of line returns
    echo -e "\n\n"
}

# Apresenta um prompt para escolher o driver
escolha_driver

# Instalando suckless build
echo "Instalando suckless build..."
bash ~/.dotfiles/.config/debian/suckless_build.sh

# Instalando display manager
echo "Instalando display manager"
bash ~/.dotfiles/.config/debian/display_manager.sh

# Gerenciador de arquivos
echo "Instalando o gerenciador de arquivos"
bash ~/.dotfiles/.config/debian/file_manager.sh

# Som
echo "Instalando som"
bash ~/.dotfiles/.config/debian/sound_manager.sh

# Players Music
echo "Instalando tocadores de musica "
bash ~/.dotfiles/.config/debian/players_music.sh

# Players Video
echo "Instalando tocadores de video "
bash ~/.dotfiles/.config/debian/players_video.sh

# Brilho tela
echo "Instalando gerenciadores de brilho"
bash ~/.dotfiles/.config/debian/laptop_brightness.sh

# Programas para customizar a aparencia
echo "Instalando customizadores de aparencia"
bash ~/.dotfiles/.config/debian/appearance_managers.sh

# IDE
echo "IDE"
bash ~/.dotfiles/.config/debian/ide_programs.sh

# Demais programas
echo "Demais programas"
bash ~/.dotfiles/.config/debian/misc_programs.sh

# Programas para notebook
install_programs_laptop() {
    echo "Instalando programas para notebook"
    bash ~/.dotfiles/.config/debian/laptop_battery.sh
}

# Funcao para o usuario escolher se vai instalar programas para notebook
escolha_notebook() {
    local wm_name="$1"
    echo "$wm_name Instalação"
    echo "1. Instalar $wm_name com programas para notebook"
    echo "Ou ENTER para pular"
    read -r choice

   case "$choice" in
        1)
            install_programs_laptop
            ;;
        *)
            echo "Pulando essa etapa, e instalando o resto..."
            ;;
    esac

    # Adding a couple of line returns
    echo -e "\n\n"
}
escolha_notebook
echo "All installations completed."
