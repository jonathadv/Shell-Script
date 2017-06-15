#!/usr/bin/env bash
#
# Name: Fix ICC profile bug
# Author: Jonatha Daguerre Vasconcelos <jonatha@daguerre.com.br>
# Version: 1.2 (14 Jun 2017)
# License: MIT
#
#                  DESCRIPTION
#
# This script is a workaround to prevent that some pictures be displayed with wrong colors.
# Source forum that this fix was suggested: https://bugs.launchpad.net/ubuntu/+source/eog/+bug/938751
# Put this file in startup folder in your graphical environment. Since I use KDE I put the script to start with KDE in $HOME/.kde/Autostart.
#
#
# Usage:
#   ./fix_icc_profile_bug.sh
#
#
#              CHANGE HISTORY
#
# 1.1 (14 Jun 2017) - Updated comments and license; replaced kdialog by creating a error log under user's HOME.
# 1.0 (27 Aug 2014) - First version
#

# The command removes ICC profile
xprop -root -remove _ICC_PROFILE 2> $$.tmp

# Storage a log in the user's HOME if some error happens.
error_message="$(cat $$.tmp)"
rm $$.tmp

if [[ -n "${error_message}" ]]; then
  echo "${error_message}" > "${HOME}/error_fix_icc_profile.log"
fi
