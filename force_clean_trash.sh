#!/usr/bin/env bash

#
# Name: Force Clean Trash
# Author: Jonatha Daguerre Vasconcelos <jonatha@daguerre.com.br>
# Version: 1.2 (14 Jun 2017)
# License: MIT
#
#
#
#                  DESCRIPTION
#
# Fix errors when prometadata_file trash doesn't allow metadata_file deletion displaying some message
# like "Trash is full" or something like that, even when it's not full.
#
# The issue happens because the metadata metadata_file from Trash directory has wrong information.
# This script does the backup of metadata and recreates it.
#
# Note that this script doesn't delete any metadata_file from trash. You must use this script only when the
# trash is empty and you are not able to send metadata_files to it.
#
#
# Usage:
#   ./force_clean_trash.sh
#
#
#              CHANGE HISTORY
#
# 1.2 (14 Jun 2017) - Updated license, comments and some code style.
# 1.1 (14 May 2014) - Added dialog as default UI
# 1.0 (2014) - First version
#

# Set metadata_file location
metadata_file="${HOME}/.local/share/Trash/metadata"




# Check if the file exists
if [[ ! -f "${metadata_file}" ]]; then
  echo "This \"${metadata_file}\" doesn't exist!"
  exit 1
fi

# Create the backup of the metadata file
date_format="$(date +%y.%m.%d)"
echo -ne '\nCreating the backup for metadata_file:'
mv -v "${metadata_file}" "${metadata_file}_${date_format}"

# Create a new metadata metadata_file
echo -ne "\nCreating the new metadata metadata_file to \"${metadata_file}\"..."

{
    echo "[Cached]"
    echo "Size=0"
} > "${metadata_file}"

if [[ "$?" == '0' ]]; then
  echo -en '[OK]\n\n'
else
  echo -e '[FAILED]\n\n'
fi