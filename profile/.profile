# Init file. Determine and set OS variables; load appropriate config.

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
  includes=$(find "${1}" -iname '*.inc' | sort)
  while read inc ; do
    source "${inc}"
  done <<< "${includes}"
}

# OS-specific includes
if $OS_OSX ; then
  source_recursively "${OSX_INC}"
elif $OS_LINUX ; then
  source_recursively "${LINUX_INC}"
elif $OS_WINDOWS ; then
  source_recursively "${WINDOWS_INC}"
fi

# Common includes
source_recursively "${COMMON_INC}"
