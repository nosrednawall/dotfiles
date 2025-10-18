#!/bin/bash

# Cria um arquivo temporário para o menu do jgmenu
MENUFILE=$(mktemp)

# Lista de layouts disponíveis e seus índices
echo "Tiled Layout ([]=)|bash='xdotool key super+1'" > $MENUFILE
echo "Floating Layout (><>)|bash='xdotool key super+2'" >> $MENUFILE
echo "Monocle Layout ([M])|bash='xdotool key super+3'" >> $MENUFILE

# Exibe o menu com jgmenu
jgmenu --simple --config-file=$MENUFILE

# Remove o arquivo temporário
rm $MENUFILE
