# This is a sample of autocomplete script which should be sourced to the shell session.
#
# <possibilities> represents any command to generate a single line list of possibilities to the autocomplete.
# <executable> is the binary/script to be run.
#
# The function _script() can have any name.

_script()
{
  _script_commands=$(<possibilities>)

  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )

  return 0
}
complete -F _script <executable>
