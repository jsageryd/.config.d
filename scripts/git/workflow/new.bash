#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo 'Need branch name'
  exit 1
fi

git fetch
git checkout -b "$1" origin/master
git push -u origin "$1"
