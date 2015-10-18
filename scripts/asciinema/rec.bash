#!/usr/bin/env bash

if ! which -s asciinema; then
  echo 'asciinema not found'
  exit 1
fi

name=$1
shift
title="$@"
title=${title:-$name}

if test -z "$name"; then
  echo "Usage:"
  echo "  rec <name> [title]"
  echo
  echo "Example:"
  echo "  rec foo Foo example"
  exit 1
fi

root="$HOME/Dropbox/asciinema"
mkdir -p "$root"
path="$root/$name.json"

if test -e "$path"; then
  echo "File exists ($path)."
  read -rp "Replace [y/n]? " answer
  if test "$answer" = 'y' -o "$answer" = 'Y'; then
    echo rm "$path"
  else
    exit 1
  fi
fi

asciinema rec --command='bash -l' --title="$title" --max-wait=3 "$path"

echo -n "$path" | pbcopy
echo "$path saved (path in clipboard)"
