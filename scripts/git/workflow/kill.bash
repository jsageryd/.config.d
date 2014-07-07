#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo 'Need branch name'
  exit 1
fi

branch_name=$(git rev-parse --abbrev-ref HEAD)
[ "$branch_name" == "$1" ] && git checkout -
git branch -D "$1"
git push origin :"$1"
