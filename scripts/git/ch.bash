#!/usr/bin/env bash

hash=$(git rev-parse --verify --short=12 ${1:-HEAD} | tr -d '\n')
printf $hash | pbcopy;
printf "Hash copied: $(git log -1 --abbrev=12 --oneline --color $hash)\n"
