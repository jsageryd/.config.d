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
    if $OS_OSX ; then
      ln -sfh $1 $2
    else
      ln -sf $1 $2
    fi
    echo "Linked $1 -> $2"
  fi
}

# Link
_link ${CONFIG_ROOT}/alacritty/.alacritty.toml ${HOME}/.alacritty.toml
_link ${CONFIG_ROOT}/bat/.bat ${HOME}/.bat
_link ${CONFIG_ROOT}/gaku/.gaku ${HOME}/.gaku
_link ${CONFIG_ROOT}/ledger/.ledgerrc ${HOME}/.ledgerrc
_link ${CONFIG_ROOT}/enscript/.enscriptrc ${HOME}/.enscriptrc
_link ${CONFIG_ROOT}/input/.inputrc ${HOME}/.inputrc
_link ${CONFIG_ROOT}/profile/.bash_profile ${HOME}/.bash_profile
_link ${CONFIG_ROOT}/profile/.bashrc ${HOME}/.bashrc
_link ${CONFIG_ROOT}/psql/.psqlrc ${HOME}/.psqlrc
_link ${CONFIG_ROOT}/tig/.tigrc ${HOME}/.tigrc
_link ${CONFIG_ROOT}/tmux/.tmux ${HOME}/.tmux
_link ${CONFIG_ROOT}/tmux/.tmux.conf ${HOME}/.tmux.conf
_link ${CONFIG_ROOT}/vim/.vimrc ${HOME}/.vimrc
if $OS_WINDOWS ; then
  _link ${CONFIG_ROOT}/git/windows/.gitconfig ${HOME}/.gitconfig
  [ -d ${HOME}/vimfiles ] && rm -rf ${HOME}/vimfiles
  _link ${CONFIG_ROOT}/vim/.vim ${HOME}/vimfiles
else
  _link ${CONFIG_ROOT}/git/.gitconfig ${HOME}/.gitconfig
  _link ${CONFIG_ROOT}/vim/.vim ${HOME}/.vim
fi
