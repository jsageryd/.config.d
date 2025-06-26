#!/bin/bash

range="HEAD"

if [ ! -z "$1" ]; then
  range="$1"
fi

git rev-list "$range" |
  while read rev; do
    echo -n "$rev "
    git ls-tree -r --format='%(objectsize)' --full-tree $rev |
      perl -lne '$x += $_; END { print $x }' |
      awk '{print $1 / 1024 / 1024}' |
      xargs -n1 printf '%.2f MiB\n'
  done
