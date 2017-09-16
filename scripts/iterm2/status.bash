#!/usr/bin/env bash

if [ -n $TMUX ]; then
  printf "\033Ptmux;\033"
  printf "\033]1337;SetKeyLabel=status=$*\a"
  printf "\033\\"
else
  printf "\033]1337;SetKeyLabel=status=$*\a"
fi
