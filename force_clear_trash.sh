#!/bin/bash

# ----------------------------------------------------------------------------
# It fixes errors when profile trash doesn't allow file deletion
# displaying some message like "Trash is full" or something like that even when it's not.
#
# The issue happens because the metadata file from Trash directory has wrong informations.
# This script does the backup of metadata and recreates it.
#
# Note that this script doesn't delete any file from trash. You must be use this script only when the
# trash is empty and you are not able to send files to it.
#
#
# Use: ./clearTrash.sh
#
#
# Author: Jonatha Daguere Vasconcelos <jonatha@daguerre.com.br>
# Since: 14/05/2014
# Version: 1.0
# Licence: GPL
# ----------------------------------------------------------------------------


# Set file location
file="${HOME}/.local/share/Trash/metadata2"




# Test the file
if [ ! -f ${file} ]
 then
  echo "This \"${file}\" doesn't exist!"
  exit 1
fi

# Create the backup file
dateFormat="$(date +%y"."%m"."%d)"
echo -ne '\nCreating the backup file: '
mv -v ${file} ${file}_${dateFormat}

# Create a new metadata file
echo -ne "\nCreating the new metadata file to \"${file}\"..."

{
    echo "[Cached]"
    echo "Size=0"
} > ${file}

([ "$?" == 0 ] && echo -en '[OK]\n\n') || echo -e '[FAILED]\n\n'
