# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# =============================================================================
# PATH CONFIGURATION - VERSÃO DEFINITIVA
# =============================================================================

export PATH=""

# Primeiro: obter o PATH base do sistema
CLEAN_PATH="/usr/local/bin:/usr/bin:/bin:/usr/games"

# Adicionar paths do usuário na ordem correta (mais genéricos primeiro)
CLEAN_PATH="$HOME/.local/bin:$CLEAN_PATH"
CLEAN_PATH="$HOME/.config/emacs/bin:$CLEAN_PATH"
CLEAN_PATH="$HOME/.local/bin/mpd:$CLEAN_PATH"

# Adicionar scripts do suckless
CLEAN_PATH="$HOME/.local/bin/dmenu:$CLEAN_PATH"
CLEAN_PATH="$HOME/.local/bin/dwm:$CLEAN_PATH"
CLEAN_PATH="$HOME/.local/bin/dwmblocks:$CLEAN_PATH"
CLEAN_PATH="$HOME/.local/bin/others:$CLEAN_PATH"

# Adicionar dotfiles
CLEAN_PATH="$HOME/.dotfiles/.local/bin:$CLEAN_PATH"

# FINALMENTE: adicionar conda no FINAL
CLEAN_PATH="$CLEAN_PATH:$HOME/miniconda3/condabin"

# Exportar o PATH limpo
export PATH="$CLEAN_PATH"

# Limpar variável temporária
unset CLEAN_PATH


# =============================================================================
# OH-MY-BASH CONFIGURATION
# =============================================================================

export OSH='/home/anderson/.oh-my-bash'

# Set name of the theme to load
OSH_THEME="vscode"

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

OMB_USE_SUDO=true

# Which completions would you like to load?
completions=(
  git
  composer
  ssh
  pip
  pip3
  gh
  defaults
  dirs
  system
)

# Which aliases would you like to load?
aliases=(
  general
)

# Which plugins would you like to load?
plugins=(
  git
  bashmarks
  pyenv
  progress
  battery
)

source "$OSH"/oh-my-bash.sh

# =============================================================================
# ALIASES (incorporado do bashrc_alias)
# =============================================================================

# Complementos
alias compila="rm config.h; make; sudo make clean install"
alias edwm="cd /home/anderson/.config/suckless/dwm"
alias flexipatch-execute="mv $HOME/.config/suckless/dwm/config.def.h \"$HOME/.config/suckless/dwm/$(date +%Y-%m-%d_%H:%M:%S)-backup-config\"; $HOME/.config/suckless/others/flexipatch/flexipatch-finalizer/flexipatch-finalizer.sh -r -d $HOME/.config/suckless/others/flexipatch/dwm-flexipatch/ -o $HOME/.config/suckless/dwm/"

alias ..='cd ..'
alias ...='cd ../..'
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias uplist='apt list --upgradable'
alias search='apt search'
alias remove='sudo apt autoremove'
alias df='df -h'
alias free='free -h'
alias myip="ip -f inet address | grep inet | grep -v 'lo$' | cut -d ' ' -f 6,13 && curl ifconfig.me && echo ' external ip'"
alias x="exit"
alias baixa_site="wget -r -erobots=off"

# YouTube downloads
alias yt='ytfzf --max-threads=4 --thumbnail-quality=maxres --features=hd -t --ii=https://yt.securityops.co'
alias baixa_mp3='yt-dlp -f bestaudio --extract-audio --audio-format m4a --embed-thumbnail --add-metadata'
alias ytmp3='yt-dlp -f bestaudio --extract-audio --audio-format m4a --audio-quality 0 -o "%(title)s.%(ext)s" '

# Git aliases
alias gp="git push -u origin main"
alias gsave="git commit -m 'save'"
alias gs="git status"
alias gc="git clone"

# Programas
alias em="emacs -nw"
alias nvidia="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias betterdiscord-update="DISC_CONFIG=\"\$HOME/.var/app/com.discordapp.Discord/config/discord\" && BD_ASAR=betterdiscord.asar && wget --timestamping -P \"\${DISC_CONFIG}/../BetterDiscord/data\" -- \"https://github.com/BetterDiscord/BetterDiscord/releases/latest/download/\${BD_ASAR}\" && DISC_VER=\"\$(ls --sort=time --time=creation \"\${DISC_CONFIG}\" | grep -E -m 1 '^[0-9]+\\.[0-9]+\\.[0-9]+\$')\" && echo -e \"require('../../../../BetterDiscord/data/\${BD_ASAR}');\\nmodule.exports = require('./core.asar');\" | tee \"\${DISC_CONFIG}/\${DISC_VER}/modules/discord_desktop_core/index.js\" && echo -e \"\\nBetterDiscord installed. Restart Discord if currently running.\" || echo -e \"\\nInstallation failed.\""
alias EDITOR="emacsclient -c -a 'emacs'"
alias mov-cli-activate="source ~/.venv/mov-cli-venv/bin/activate"
alias aquario="/usr/local/bin/asciiquarium"
alias live_wallpaper="xwinwrap -g 1920x1080 -ov -debug -- mpv --no-audio --loop --no-border -wid WID --panscan=1 --geometry=100%:100% '.wallpapers/live-wallpaper/initiald/toyota-ae86-drifting-initial-d-moewalls-com.mp4'"

# Conda
alias R-env="conda activate r-env"

# =============================================================================
# CONDA CONFIGURATION
# =============================================================================

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/anderson/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/anderson/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/anderson/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/anderson/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# =============================================================================
# FUNÇÕES E CONFIGURAÇÕES ADICIONAIS
# =============================================================================

unset MAILCHECK

# Source do tema selecionado (se existir)
if [ -f "$HOME/.theme_selected" ]; then
    source "$HOME/.theme_selected"
fi
