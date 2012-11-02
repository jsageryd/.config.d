#!/usr/bin/env bash

# Directory of this script
CONFIG_ROOT=$(cd `dirname $0` && pwd)

# Store location of config root
echo "CONFIG_ROOT='${CONFIG_ROOT}'" > ${HOME}/.config_root

# Determine OS
source ${CONFIG_ROOT}/determine_os

# Handle Windows
function _link() {
  if $OS_WINDOWS ; then
    cp -a $1 $2
    echo "Copied $1 -> $2"
  else
    ln -sf $1 $2
    echo "Linked $1 -> $2"
  fi
}

# Link
_link ${CONFIG_ROOT}/profile/.profile ${HOME}/
_link ${CONFIG_ROOT}/vim/.vimrc ${HOME}/
if $OS_WINDOWS ; then
  _link ${CONFIG_ROOT}/git/windows/.gitconfig ${HOME}/
  [ -d ${HOME}/vimfiles ] && rm -rf ${HOME}/vimfiles
  _link ${CONFIG_ROOT}/vim/.vim ${HOME}/vimfiles
else
  _link ${CONFIG_ROOT}/git/.gitconfig ${HOME}/
  _link ${CONFIG_ROOT}/vim/.vim ${HOME}/
fi
