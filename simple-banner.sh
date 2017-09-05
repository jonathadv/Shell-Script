##########################
#
# Function to print a simple
# banner as below.
#
#  +---------------+
#  |               |
#  | simple banner |
#  |               |
#  +---------------+
#
##########################
function banner(){
    local message="$*"
    local edge_length=$((${#message}+2))
    local banner_edge='-'
    local banner_edge_template="$(printf "%-${edge_length}s" "")"
    local banner_edge="${banner_edge_template// /$banner_edge}"

    echo "+${banner_edge}+"
    echo "|${banner_edge_template}|"
    echo "| ${message} |"
    echo "|${banner_edge_template}|"
    echo "+${banner_edge}+"
}