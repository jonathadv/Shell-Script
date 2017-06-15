#
#
#                  DESCRIPTION
#
# This is a sample of autocomplete script which should be sourced to the shell session.
# 
# Usage:
#    source auto_complete_sample.sh
#
# Variables:
#   params_to_choose: is a list of possibilities to the autocomplete. 
#   It can be a hardcoded list or a command to generate one.
#
#   executable_file: is the binary/script to be run.
#
# The function name "_script()" is a arbitrary name.
#
# Result Examples:
#   $ foo <TAB> <TAB>
#   $ bar  bar1  bar2  barN  foo1  foo2  fooN 
#
#   $ foo b <TAB>
#   $ foo bar <TAB>
#   $ bar  bar1  bar2  barN

declare -r executable_file="foo"
declare -r params_to_choose="bar bar1 bar2 barN foo1 foo2 fooN"

function _script() {
  _script_commands=${params_to_choose}

  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )

  return 0
}

complete -F _script ${executable_file}
