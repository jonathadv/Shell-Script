#!/bin/bash
#
# ----------------------------------------------------------------------------
# This script is a workaround to prevent that some pictures be displayed with wrong colors.
# Source forum that this fix was suggested: https://bugs.launchpad.net/ubuntu/+source/eog/+bug/938751
# Put this file in startup folder in your graphical environment. Since I use KDE I put the script to start with KDE in $HOME/.kde/Autostart.
#
# Author: Jonatha Daguerre Vasconcelos
# Version: 1.0
# Date: 27/08/2014
# Licence: GPL
# ----------------------------------------------------------------------------


# The command removes ICC profile
xprop -root -remove _ICC_PROFILE 2> $$.tmp


# This command is just to let the user know that the command failed.
ERROR_MESSAGE=$(cat $$.tmp)
rm $$.tmp

if [ -n "${ERROR_MESSAGE}" ]
 then
  kdialog --error "Fail to remove \"_CC_PROFILE!\"\n\n${ERROR_MESSAGE}"
fi


