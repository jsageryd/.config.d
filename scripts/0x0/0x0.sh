#!/bin/sh

# This script uploads the given file(s) to 0x0.st and prints the returned URL(s).

if test -z "$1"; then
  echo 'Usage: 0x0 <file> [<file> ...]'
  exit 1
fi

for file in "$@"; do
  if test ! -f "$file"; then
    printf 'Not a regular file: \e[38;5;190m%s\e[0m\n' "$file"
    exit 1
  fi
  printf '\e[38;5;190m%s\e[0m\n' "$file"
done

read -r -n1 -p "Share to 0x0.st [y/n]? " answer
echo
if test "$answer" = 'y' -o "$answer" = 'Y'; then
  for file in "$@"; do
    url=$(curl -A '0x0 uploader script' -sF file=@"$file" https://0x0.st/)
    printf '\e[38;5;190m%s\e[0m\n' $url >&2
    echo "$url"
  done | paste -s -d ' ' - | tr -d '\n' | pbcopy &&
  printf '%d URL(s) copied to clipboard\n' $#
fi
