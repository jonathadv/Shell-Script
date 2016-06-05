#!/bin/bash
#
# ----------------------------------------------------------------------------
# Description: Script to install Adobe Flash Player in Linux machines with Mozilla Firefox.
#
# Usage:
#
# Local installation:
# sudo ./install_flash_player.sh <tarball_file.tar.gz>
#
# Internet intallation:
# sudo ./install_flash_player.sh --update <flashplayer version>
#
# e.g: ./install_flash_player.sh --update 11.2.202.521
#
# You can get the latest version of Flash Player in that URL: https://get.adobe.com/br/flashplayer/
#
# TODO: It should be refactored!
#
# Author: Jonatha Daguerre Vasconcelos
# Version: 1.0
# Date: 03/10/2015
# Licence: GPL
# ----------------------------------------------------------------------------
#
# Default URL for download: https://fpdownload.adobe.com/get/flashplayer/pdc/11.2.202.508/install_flash_player_11_linux.x86_64.tar.gz
#

set -o xtrace

IS_UPDATE=0
FLASH_VERSION='11.2.202.621' # Default value
FLASH_TARBALL_NAME='install_flash_player_11_linux.x86_64.tar.gz' # Default value
FILENAME='adobe-flashplugin.tar.gz'
TMP_DIR='/tmp/adobe_flashplugin_installer'

if [ "${1}" == "--update" ];then
    IS_UPDATE=1
    [ -n "${2}" ] && FLASH_VERSION=${2}
else
    flash_tarball="${1}"
fi





fp_exit_with_error() {
    echo -en "$1"
    echo "Some error happend! The Flash plugin was NOT installed."
    exit 1
}

check_root(){

    if [[ "$(id -u)" != "0" ]];then
        fp_exit_with_error "Must do be root to install Flash Player plugin."
    fi
}

check_last_plugin_version(){
    echo "Checking the latest version of Flash Plugin..."
    local flash_last_version=$(curl 'https://get.adobe.com/br/flashplayer/'  \
        -H 'Host: get.adobe.com'  \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.8.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
        -H 'Accept-Language: pt-BR,en-US;q=0.7,en;q=0.3' --compressed  \
        -H 'Referer: http://www.adobe.com/devnet/flashplayer.html'  \
        -H 'Connection: keep-alive'  \
        -H 'Pragma: no-cache'  \
        -H 'Cache-Control: no-cache'  \
        2> /dev/null \
    | egrep --color=auto '11.[0-9.]{4,20}\b' -o | head -1)

    if [[ -n "${flash_last_version}" ]]; then
        echo "The latest Flash plugin version is ${flash_last_version}."
        FLASH_VERSION="${flash_last_version}"
    else
        echo "Unable to retrive the latest version of Flash plugin. Trying to install the default version: ${FLASH_VERSION}"
    fi
}

setup_files(){

#    if [[ -z ${flash_tarball} ]];then
#        fp_exit_with_error "Please send the tarball file as parameter:\n$0 adobe-flashplugin.tar.gz \n\nor if you want to update it via internet, use:\n$0 --update <version>.\n\n"
#    fi

    if [[ ${IS_UPDATE} = "1" ]];then
        check_last_plugin_version
        wget -v https://fpdownload.adobe.com/get/flashplayer/pdc/${FLASH_VERSION}/${FLASH_TARBALL_NAME}
        flash_tarball="${FLASH_TARBALL_NAME}"
    else
        echo "Updating from local file..."
        if [[ ! -f ${flash_tarball} ]];then
            fp_exit_with_error "File \"${flash_tarball}\" doesn't exist!"
        fi
    fi

    if [[ -z ${TMP_DIR} ]];then
        fp_exit_with_error "Temp directory not set. Please set a value for it."
    fi

    if [[ -d ${TMP_DIR} ]];then
        rm -rf ${TMP_DIR}
    fi

    mkdir -p ${TMP_DIR}

    cp -f "${flash_tarball}" "${TMP_DIR}/${FILENAME}"

    cd "${TMP_DIR}"
}


untar_file(){

    tar -xzf $FILENAME || fp_exit_with_error "cannot unpack plugin"
}

check_installation_files(){


    if [[ ! -f 'libflashplayer.so' ]];then
        fp_exit_with_error "Missing file ${TMP_DIR}/libflashplayer.so"
    fi

    if [[ ! -d 'usr/bin' ]];then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/bin"
    fi

    if [[ ! -d 'usr/lib' ]];then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/lib"
    fi

    if [[ ! -d 'usr/lib64' ]];then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/lib64"
    fi

    if [[ ! -d 'usr/share' ]];then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/share"
    fi

}

install_plugin(){
    echo ''
    echo -n "Installing ${TMP_DIR}/libflashplayer.so to /usr/lib/flashplugin-installer/"
    install -m 644 ${TMP_DIR}/libflashplayer.so /usr/lib/flashplugin-installer/

    if [[ "$?" == "0" ]];then
        echo '  ...............[Done]'
    else
        fp_exit_with_error "Error when intalling libflashplayer.so"
    fi
}


update_alternatives(){
    echo ''
    echo -n "Running update-alternatives for /usr/lib/flashplugin-installer/libflashplayer.so"
    update-alternatives --install "/usr/lib/mozilla/plugins/flashplugin-alternative.so" "mozilla-flashplugin" /usr/lib/flashplugin-installer/libflashplayer.so 50

    if [[ "$?" == "0" ]];then
        echo '  ...............................[Done]'
    else
        fp_exit_with_error "Error when configuring update-alternatives for libflashplayer.so"
    fi
}


configure_extras(){
    echo ''
    echo -n "Configuring extra files"


    cp -f ${TMP_DIR}/usr/bin/flash-player-properties /usr/bin
    chmod 755 /usr/bin/flash-player-properties

    cp -f ${TMP_DIR}/usr/lib64/kde4/kcm_adobe_flash_player.so /usr/lib/kde4/
    chmod 622 /usr/lib/kde4/kcm_adobe_flash_player.so

    cp -f ${TMP_DIR}/usr/share/applications/flash-player-properties.desktop /usr/share/applications/
    chmod 755 /usr/share/applications/flash-player-properties.desktop

    cp -fR ${TMP_DIR}/usr/share/icons/hicolor /usr/share/icons/hicolor

    cp -f ${TMP_DIR}/usr/share/kde4/services/kcm_adobe_flash_player.desktop /usr/share/kde4/services/
    chmod 622 /usr/share/kde4/services/kcm_adobe_flash_player.desktop

    cp -f ${TMP_DIR}/usr/share/pixmaps/flash-player-properties.png /usr/share/pixmaps/
    chmod 622 /usr/share/pixmaps/flash-player-properties.png


    if [[ "$?" == "0" ]];then
        echo '  ........................................................................................[Done]'
    else
        fp_exit_with_error "Error when configuring extras."
    fi

    echo ''
    echo ''

}


remove_tmp_files(){
    rm -rf "${TMP_DIR:=/tmp/adobe_flashplugin_installer}"
}


print_start(){

    echo -en "\n\n\t#### #### #### #### #### ####\n"
    echo -en "\t##                         ##\n"
    echo -en "\t##   FlashPlayer Installer ##\n"
    echo -en "\t##    By Jonatha Daguerre  ##\n"
    echo -en "\t##                         ##\n"
    echo -en "\t#### #### #### #### #### ####\n"

}

print_end(){

    echo -en "\t#### #### #### #### #### ####\n"
    echo -en "\t####                     ####\n"
    echo -en "\t####       I T'  S       ####\n"
    echo -en "\t####       D O N E       ####\n"
    echo -en "\t####                     ####\n"
    echo -en "\t#### #### #### #### #### ####\n"
}


#
# Calling the functions...
#

print_start
check_root
setup_files
untar_file
check_installation_files
install_plugin
update_alternatives
configure_extras
remove_tmp_files
print_end
