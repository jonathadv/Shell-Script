#!/bin/bash
#
# ----------------------------------------------------------------------------
# Description: Script to install Adobe Flash Player in GNU/Linux machines with Mozilla Firefox.
# It downloads the tarball direct from Adobe web site.
#
# Author: Jonatha Daguerre Vasconcelos <jonatha@daguerre.com.br>
# Version: 2.0
# Date: 20/07/2016
# Licence: GPL
#
# Usage:
# sudo ./install_flash_player.sh
#
#

set -o pipefail
set -o nounset

FLASH_TARBALL_NAME='flash_player_npapi_linux.x86_64.tar.gz'
TMP_DIR="$(mktemp -d)"

function fp_exit_with_error() {
    local red='\033[0;31m'
    local nc='\033[0m'

    echo
    echo
    echo -en "\t+------------------------------+\n"
    echo -en "\t|                              |\n"
    echo -en "\t| The installation has failed! |\n"
    echo -en "\t|                              |\n"
    echo -en "\t+------------------------------+\n"
    echo
    echo -en "${red}Cause: ${*}${nc}\n"
    echo
    echo
    remove_tmp_files
    exit 1
}

function check_root(){

    if [[ "$(id -u)" != "0" ]];then
        fp_exit_with_error "Must be root to install Flash Player plugin."
    fi
}

function check_last_plugin_version(){
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
    | egrep --color=auto '2[0-9].[0-9.]{4,20}\b' -o | head -1)

    if [[ -n "${flash_last_version}" ]]; then
        printf '%s' "${flash_last_version}"
    else
        fp_exit_with_error 'Unable to retrive the latest version of Flash plugin from internet.'
    fi
}

function download_tarball(){
    local version="${1}"
    local url="https://fpdownload.adobe.com/get/flashplayer/pdc/${version}/${FLASH_TARBALL_NAME}"

    echo "Flash Player version is: ${version}"
    echo "Trying to download file from ${url}..."
    echo

    wget -v "${url}" -O "${TMP_DIR}/${FLASH_TARBALL_NAME}"

    [[ "${?}" != '0'  ]] && fp_exit_with_error "Unable to download the Flash plugin tarball from ${url}"
}


function untar_file(){
    cd "${TMP_DIR}"
    tar -xzf ${FLASH_TARBALL_NAME} || fp_exit_with_error "Unable to unpack the plugin."
}

function check_installation_files(){
    cd "${TMP_DIR}"

    if [[ ! -f 'libflashplayer.so' ]]; then
        fp_exit_with_error "Missing file ${TMP_DIR}/libflashplayer.so"
    fi

    if [[ ! -d 'usr/bin' ]]; then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/bin"
    fi

    if [[ ! -d 'usr/lib' ]]; then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/lib"
    fi

    if [[ ! -d 'usr/lib64' ]]; then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/lib64"
    fi

    if [[ ! -d 'usr/share' ]]; then
        fp_exit_with_error "Missing directory ${TMP_DIR}/usr/share"
    fi

}

function install_plugin(){
    local plugin_lib_dir='/usr/lib'

    if [[ -d "${plugin_lib_dir}/adobe-flashplugin" ]]; then
        plugin_lib_dir="${plugin_lib_dir}/adobe-flashplugin"
    else
        plugin_lib_dir="${plugin_lib_dir}/flashplugin-installer"
    fi
    
    if [[ ! -d "${plugin_lib_dir}" ]]; then
        mkdir -p "${plugin_lib_dir}"
        chmod 755 "${plugin_lib_dir}"
    fi

    echo
    echo -n "Installing ${TMP_DIR}/libflashplayer.so to ${plugin_lib_dir}"

    install -m 644 "${TMP_DIR}/libflashplayer.so" "${plugin_lib_dir}"

    [[ "${?}" != '0' ]] && fp_exit_with_error "Error when intalling libflashplayer.so"
    
    echo '  ................[Done]'
	
    
    update_alternatives "${plugin_lib_dir}"

    configure_extras
}


function update_alternatives(){
    local plugin_lib_dir="${1}"
    
    echo
    echo -n "Running update-alternatives for ${plugin_lib_dir}/libflashplayer.so"
    update-alternatives --install "/usr/lib/mozilla/plugins/flashplugin-alternative.so" "mozilla-flashplugin" "${plugin_lib_dir}/libflashplayer.so" 50

    if [[ "$?" == '0' ]]; then
        echo '  ..................[Done]'
    else
        fp_exit_with_error "Error when configuring update-alternatives for libflashplayer.so"
    fi
}


function configure_extras(){
    echo
    echo -n "Configuring extra files"


    cp -f "${TMP_DIR}/usr/bin/flash-player-properties" /usr/bin
    chmod 755 /usr/bin/flash-player-properties

    if [[ -d /usr/lib/kde4/ ]]; then
        cp -f "${TMP_DIR}/usr/lib64/kde4/kcm_adobe_flash_player.so" /usr/lib/kde4/
        chmod 622 /usr/lib/kde4/kcm_adobe_flash_player.so
    fi

    if [[ -d /usr/share/kde4/services ]]; then
        cp -f "${TMP_DIR}/usr/share/kde4/services/kcm_adobe_flash_player.desktop" /usr/share/kde4/services/
        chmod 622 /usr/share/kde4/services/kcm_adobe_flash_player.desktop
    fi

    cp -f "${TMP_DIR}/usr/share/applications/flash-player-properties.desktop" /usr/share/applications/
    chmod 755 /usr/share/applications/flash-player-properties.desktop

    cp -fR "${TMP_DIR}/usr/share/icons/hicolor" /usr/share/icons/hicolor

    cp -f "${TMP_DIR}/usr/share/pixmaps/flash-player-properties.png" /usr/share/pixmaps/
    chmod 622 /usr/share/pixmaps/flash-player-properties.png


    if [[ "$?" == '0' ]]; then
        echo '  ...........................................................................[Done]'
    else
        fp_exit_with_error "Error when configuring extras."
    fi

    echo
    echo

}


function remove_tmp_files(){
    echo 'Removing temp files...'
    rm -rf "${TMP_DIR:=/tmp/adobe_flashplugin_installer}"
}


function print_start(){
    echo
    echo
    echo -en "\t+---------------------------+\n"
    echo -en "\t|                           |\n"
    echo -en "\t|    FlashPlayer Installer  |\n"
    echo -en "\t|                           |\n"
    echo -en "\t+---------------------------+\n"
    echo
    echo
}


function print_end(){
    echo
    echo
    echo -en "\t+---------------------------+\n"
    echo -en "\t|                           |\n"
    echo -en "\t| The installation is done! |\n"
    echo -en "\t|                           |\n"
    echo -en "\t+---------------------------+\n"
    echo
    echo
}


function main(){
    print_start
    check_root
    local version=$(check_last_plugin_version)

    [[ -z "${version}" ]] && fp_exit_with_error 'Unable to get the lastest Flash Plugin Version.'

    download_tarball "${version}"

    untar_file

    check_installation_files

    install_plugin    

    remove_tmp_files

    print_end

}


# Let's start it!
main
