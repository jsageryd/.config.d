#!/usr/bin/env bash

if [ -n $TMUX ]; then
  printf "\033Ptmux;\033"
  printf "\033]0;$*\a"
  printf "\033\\"
else
  printf "\033]0;$*\a"
fi
