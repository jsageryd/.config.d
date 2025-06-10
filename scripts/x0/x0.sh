#!/bin/sh

# This script uploads the given file(s) to x0.at and prints the returned URL(s).

if [ "$COLOUR_SCHEME" = "light" ]; then
  hl="\e[48;5;190m%s\e[0m"
else
  hl="\e[38;5;190m%s\e[0m"
fi

if test -z "$1"; then
  echo 'Usage: x0 <file> [<file> ...]'
  exit 1
fi

for file in "$@"; do
  if test ! -f "$file"; then
    printf "Not a regular file: $hl\n" "$file"
    exit 1
  fi
  printf "$hl\n" "$file"
done

read -r -n1 -p "Share to x0.at [y/n]? " answer
echo
if test "$answer" = 'y' -o "$answer" = 'Y'; then
  for file in "$@"; do
    url=$(curl -sF file=@"$file" https://x0.at/)
    printf "$hl\n" $url >&2
    echo "$url"
  done | paste -s -d ' ' - | tr -d '\n' | pbcopy &&
  printf '%d URL(s) copied to clipboard\n' $#
fi
