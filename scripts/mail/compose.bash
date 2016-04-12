#!/usr/bin/env bash

maildir="$HOME/Desktop/mail"

mkdir -p "$maildir"

if [ ! -z $1 ]; then
  prefix=$1
else
  prefix="mail"
fi

name="${prefix}_$(date +'%Y-%m-%d_%H%M%S').mail"
path="$maildir/$name"

vim "$path"

if [ -f "$path" ]; then
  cat "$path" | pbcopy
  echo "Copied $path"
else
  echo Aborted
fi
