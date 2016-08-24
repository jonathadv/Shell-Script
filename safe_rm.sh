function rm(){    
    if [[ -f '/usr/bin/gvfs-trash' ]]; then
        echo "--- safe rm ($(gvfs-trash --version)) ---"

        if /usr/bin/gvfs-trash "${@}"; then
            echo "File(s) [${@}] sent to trash."
        else
           echo "Error when deleting file(s): ${@}"
        fi

        echo '------------------------------'
    
    else   
        local trash="${HOME}/.trash"
        [[ ! -d "${trash}" ]] && mkdir "${trash}"
        
        if ((${#@} < 1)); then
            echo '[safe rm]: missing operand'
            echo 'Try `rm --help` for more information'
            return 1
        fi
        
        if [[ "$1" == "--help" ]]; then
            echo "Usage: rm FILE..."
            echo "Move files to ${trash} instead of delete them permanently."
            return 0
        fi
        
        echo '--- safe rm ---'
        for file in $@; do
        
            if [[ -f "${file}" || -d "${file}" ]]; then
                file="${file/%\//}"
                mv -v "${file/%\//}" ${trash}/${file}.$(date +%s);
                
            else
                echo "[safe rm]: cannot stat ‘${file}’: No such file or directory"
                continue
            fi
            
        done
        
        echo
        echo "Trash size: $(du -sh ${trash})"
        echo '---------------'
    fi
}