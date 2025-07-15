#!/bin/bash

if ! git diff --quiet; then
  echo "Working tree not clean" >&2
  exit 1
fi

if [ -z "$1" ]; then
  echo "Need range" >&2
  exit 1
fi

range="$1"

orig="$(git rev-parse --abbrev-ref HEAD)"

green="\033[38;5;190m"
red="\033[38;5;196m"
reset="\033[0m"

git rev-list "$range" |
  while read -r rev; do
    git checkout "$rev" >/dev/null 2>&1 || exit 1

    go test -count=1 ./... >/dev/null 2>&1
    test_exit=$?

    staticcheck ./... >/dev/null 2>&1
    staticcheck_exit=$?

    if [ "$test_exit" -eq 0 ]; then
      test_indicator="[ ${green}go test -count=1 ./...${reset} | ${green}OK${reset} ]"
    else
      test_indicator="[ ${red}go test -count=1 ./...${reset} | ${red}--${reset} ]"
    fi

    if [ "$staticcheck_exit" -eq 0 ]; then
      staticcheck_indicator="[ ${green}staticcheck ./...${reset} | ${green}OK${reset} ]"
    else
      staticcheck_indicator="[ ${red}staticcheck ./...${reset} | ${red}--${reset} ]"
    fi

    printf "%b %b " "$test_indicator" "$staticcheck_indicator"
    git --no-pager log -1 --format='tformat:%C(240)%h%C(reset) %C(245)%an%C(240) %C(255)%<(60,trunc)%s%C(reset)'
  done

git checkout "$orig" >/dev/null 2>&1 || exit 1
