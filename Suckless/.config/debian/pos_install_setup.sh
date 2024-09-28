#!/bin/bash
#
# Install programs for Debian Desktop


#######################################
# Choises for initial configuration
# Globals:
#   None
# Arguments:
#   None
#######################################
install_xfce4_base() {
    echo "Installing XFCE4 Software..."

    # Session Manager
    sudo apt install -y lightdm  lightdm-gtk-greeter

    choise_laptop_acer() {
        echo "This hardware is a Acer Laptop? If Yes then install this configuration"
        echo "1. Install script for change primary monitor in lightdm"
        echo "Or Enter to skip..."
        read -r choice

        case "$choice" in
             1)
                 # Configure laptop monitor to first in lightdm
                 sudo cat > /usr/share/multiple-monitors.sh << EOF
#!/bin/bash
xrandr --output  HDMI-0 --off --output eDP-1-1 --primary --mode 1920x1080 --rotate normal --dpi 96
EOF
                 sudo chmod +x /usr/share/multiple-monitors.sh
                 sudo sed -i 's|^\#display-setup-script=|display-setup-script=/usr/share/multiple-monitors.sh|' /etc/lightdm/lightdm.conf
                 ;;
             *)
                 echo "Skiping ...."
                 ;;
        esac

        # Adding a couple of line returns
        echo -e "\n\n"
    }
    choise_laptop_acer

    # Enable the service
    sudo systemctl enable lightdm.service

    # Appearence
    sudo apt install -y numix-icon-theme-circle papirus-icon-theme lxappearance qt5ct qt5-style-plugins

    # File manager
    sudo apt install -y thunar ranger thunar-archive-plugin thunar-media-tags-plugin gvfs-backends gvfs-bin smbclient samba

    # extracao de arquivos
    sudo apt install -y arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar unace unzip xz-utils zip xarchiver

    # Battery
    sudo apt install -y xfce4-power-manager tlp
    sudo systemctl enable --now tlp

    # Brightness
    sudo apt install -y brightnessctl redshift

    # Sound
    choise_sound_program(){
        echo "Select your sound software prefer:"
        echo "1. Pulseaudio"
        echo "2. Pipewire"
        echo "Or Enter to skip..."
        read -r choice

        case "$choice" in
             1)
                 sudo apt install -y pulseaudio pavucontrol pamixer
                 ;;
             2)
                 sudo apt install pipewire pipewire-pulse wireplumber pipewire-media-session pulsemixer
                 systemctl --user --now enable wireplumber.service
                 ;;
             *)
                 echo "skiping ..."
                 ;;
        esac
        # Adding a couple of line returns
        echo -e "\n\n"
    }

    choise_sound_program

    # Music
    sudo apt install -y playerctl mpd ncmpcpp mpc
    sudo systemctl disable mpd  # Disable service
    sudo systemctl stop  mpd  # Stop
    systemctl --user enable mpd  # Enable by user

    # Video
    sudo apt install -y mpv ytfzf vlc yt-dlp

    # Pass, qtpass, pinentry e askpass
    sudo apt install -y pass qtpass pinentry-gnome3 ssh-askpass-gnome

    # Fonts
    sudo apt install -y cabextract curl fontconfig xfonts-utils
    sudo apt install -y ttf-mscorefonts-installer

    # Office
    sudo apt install -y libreoffice-gtk3 libreoffice-l10n-pt-br libreoffice atril xournalpp qalculate-gtk

    # Programs for tilling windows managers
    sudo apt install -y feh rofi network-manager xautolock picom dunst xdotool copyq solaar blueman flameshot btop libnotify-bin gpicview

    # Google-chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    sudo apt install -f -y
    rm -rf google-chrome-stable_current_amd64.deb

}




#######################################
# Choises for initial configuration
# Globals:
#   None
# Arguments:
#   None
#######################################
choise_setup() {
    echo "1. Configure folders home"
    echo "2. Install LXDE Base"
    echo "3. Install LDQT Base"
    echo "4. Install XFCE4 Base"
    echo "5. Install Suckless software (DWM, Dmenu, Slock and ST)"
    echo "Or ENTER for exit"
    read -r choice

   case "$choice" in
        1)
            # Criacao de pastas
            echo "Will Create folders  pattern in portuguese"
            mkdir -p /home/$USER/{Desktop,Downloads,Documentos,git,Imagens/Screenshoots,Músicas,.lyrics,.programas,.appimage}
            ;;
        2)
            install_lxde_base
            ;;
        3)
            install_lxqt_base
            ;;
        4)
            install_xfce4_base
            ;;
        5)
            install_suckless_base
            ;;
        *)
            echo "Exiting..."
            ;;
    esac

    # Adding a couple of line returns
    echo -e "\n\n"
}

# Invoke function
choise_setup


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
