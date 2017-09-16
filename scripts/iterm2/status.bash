#!/usr/bin/env bash

if [ -n $TMUX ]; then
  echo -en "\033Ptmux;\033"
  echo -en "\033]1337;SetKeyLabel=status=$*\a"
  echo -en "\033\\"
else
  echo -en "\033]1337;SetKeyLabel=status=$*\a"
fi
