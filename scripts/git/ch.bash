#!/usr/bin/env bash

hash=$(git rev-parse --verify --short=16 ${1:-HEAD} | tr -d '\n')
printf '%s' "$hash" | pbcopy;
printf 'Hash copied: %s\n' "$(git log -1 --abbrev=16 --oneline --color $hash)"
