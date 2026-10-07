# Init file. Determine and set OS variables; load appropriate config.

# History comes first and depends on nothing, so it survives the rest of this
# file failing.
#
# ~/.bash_history is meant to be append-only (chflags uappnd), which the
# kernel enforces against any bash, configured or not. Never truncate it
# (HISTFILESIZE=-1) and always append (histappend), so bash never attempts
# a write the flag would reject.
HISTSIZE=100000
HISTFILESIZE=-1
shopt -s histappend

# Daily snapshot of the history, kept for 90 days. Covers what the flag does
# not: the flag being removed, or edits made while it is off.
_history_backup_dir=${HOME}/.bash_history_backup
_history_backup=${_history_backup_dir}/.bash_history_$(date +%F)
if [ -s "${HOME}/.bash_history" ] && [ ! -e "${_history_backup}" ]; then
  mkdir -p "${_history_backup_dir}" &&
    cp "${HOME}/.bash_history" "${_history_backup}" &&
    find "${_history_backup_dir}" -maxdepth 1 -type f \
      -name '.bash_history_????-??-??' -mtime +90 -delete
fi
unset _history_backup_dir _history_backup

# Set config root
source ${HOME}/.config_root

# Determine OS
source ${CONFIG_ROOT}/determine_os

# Include file paths
COMMON_INC=${CONFIG_ROOT}/profile/common
OSX_INC=${CONFIG_ROOT}/profile/osx
LINUX_INC=${CONFIG_ROOT}/profile/linux
WINDOWS_INC=${CONFIG_ROOT}/profile/windows

# Recursive source
function source_recursively() {
  [ -d "${1}" ] || return 1
  includes=$(find "${1}" -iname '*.inc' | sort)
  while read inc ; do
    [ -f "${inc}" ] && source "${inc}"
  done <<< "${includes}"
}

# Common includes
source_recursively "${COMMON_INC}"

# OS-specific includes
if $OS_OSX ; then
  source_recursively "${OSX_INC}"
elif $OS_LINUX ; then
  source_recursively "${LINUX_INC}"
elif $OS_WINDOWS ; then
  source_recursively "${WINDOWS_INC}"
fi
