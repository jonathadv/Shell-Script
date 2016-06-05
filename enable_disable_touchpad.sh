#!/bin/bash

# ----------------------------------------------------------------------------
# Script para ativar e desativar touchpad. Possui suporte aos popups do KDE e GNOME
# Dependencia: synclient X.Org (http://www.x.org/archive/X11R7.5/doc/man/man1/synclient.1.html)
#
# Autor: Jonatha Daguerre Vasconcelos
# Data: 23/06/2013
# Lincença: GPL
# ----------------------------------------------------------------------------

# Verifica estado to touchpad (ativado/desativado)
TP_STATUS=$(synclient -l | grep TouchpadOff | awk '{print $3}')

# Inicia variavel que ira armazenar a flag de novo status do touchpad
TP_NEW_STATUS=1

# Inicializa variavel com a flag de suporte ao KDE ou GNOME
DIALOG_SUPORTE=""

# Mensagens
TP_HABILITADO="O Touchpad está habilitado!"
TP_DESABILITADO="O Touchpad está desabilitado!"
MSG_PADRAO="Para ativar popup do KDE use o parâmetro -k. Para ativar o do GNOME use -g"

# Funcao que lanca a mensagem no popup do KDE ou do GNOME

function mensagem {
        case $1 in
                0) kdialog --passivepopup "$2" 2 2> /dev/null ;;
                1) notify-send "$2" 2> /dev/null ;;
        2) echo "$2"
        esac
}


# Habilita Popup do KDE ou GNOME
if [ "$1" != "" ]
    then
        case $1 in
        -k) DIALOG_SUPORTE=0 ;;
        -g) DIALOG_SUPORTE=1 ;;
         *) mensagem "2" "$MSG_PADRAO" && exit 0 ;; 
    esac
fi




# Condicao para alterar estado do touchpad
if [ "$TP_STATUS" = "0" ]
    then TP_NEW_STATUS=1;
else     
    if [ "$TP_STATUS" = "1" ]
            then TP_NEW_STATUS=0;
    fi
fi



# Funcao que lanca a mensagem no popup do KDE ou do GNOME

case $TP_NEW_STATUS in
1)    
    synclient TouchpadOff=1;
    echo "$TP_DESABILITADO" 
    if [ "$DIALOG_SUPORTE" != "" ];then mensagem "$DIALOG_SUPORTE" "$TP_DESABILITADO";fi ;;

0)    synclient TouchpadOff=0  
    echo "$TP_HABILITADO" 
    if [ "$DIALOG_SUPORTE" != "" ];then mensagem "$DIALOG_SUPORTE" "$TP_HABILITADO";fi ;;

*)     echo "$MSG_PADRAO"
    
esac

exit 0
