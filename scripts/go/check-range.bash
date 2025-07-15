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

if git symbolic-ref -q HEAD >/dev/null; then
  orig="$(git rev-parse --abbrev-ref HEAD)"
else
  orig="$(git rev-parse HEAD)"
fi

green="\033[38;5;190m"
red="\033[38;5;196m"
blue="\033[38;5;33m"
grey="\033[38;5;240m"
reset="\033[0m"

git rev-list "$range" |
  while read -r rev; do
    git checkout "$rev" >/dev/null 2>&1 || exit 1

    go test -count=1 ./... >/dev/null 2>&1 &
    test_pid=$!

    staticcheck ./... >/dev/null 2>&1 &
    staticcheck_pid=$!

    wait $test_pid
    test_exit=$?

    wait $staticcheck_pid
    staticcheck_exit=$?

    todo_count=$(ag "TODO" --hidden --ignore-dir=vendor --ignore-dir=.git 2>/dev/null </dev/null | wc -l | tr -d ' ')

    if [ "$test_exit" -eq 0 ]; then
      test_status="${green}go test OK${reset}"
    else
      test_status="${red}go test --${reset}"
    fi

    if [ "$staticcheck_exit" -eq 0 ]; then
      staticcheck_status="${green}staticcheck OK${reset}"
    else
      staticcheck_status="${red}staticcheck --${reset}"
    fi

    if [ "$todo_count" -eq 0 ]; then
      todo_status="${grey}0 TODOs${reset}"
    else
      todo_status="${blue}${todo_count} TODOs${reset}"
    fi

    printf "[ %b | %b | %b ] " "$test_status" "$staticcheck_status" "$todo_status"
    git --no-pager log -1 --format='tformat:%C(240)%h%C(reset) %C(245)%an%C(240) %C(255)%<(60,trunc)%s%C(reset)'
  done

git checkout "$orig" >/dev/null 2>&1 || exit 1
