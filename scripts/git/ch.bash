#!/usr/bin/env bash

hash=$(git rev-parse --verify --short=16 --end-of-options ${1:-HEAD} | tr -d '\n')
printf '%s' "$hash" | pbcopy;
printf 'Hash copied: %s\n' "$(git log -1 --abbrev=16 --oneline --color --end-of-options $hash)"
