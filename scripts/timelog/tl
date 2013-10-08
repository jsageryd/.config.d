#!/usr/bin/env bash

# Time log

if [ -z "$LEDGER_TIMELOG" ]; then
  echo '$LEDGER_TIMELOG not set. Set it to the path of the timelog file.' >&2
  exit 1
fi

loop=false
if [ "$1" = 'loop' ]; then
  shift
  loop=true
fi

if [ $# -eq 0 ]; then
  echo 'Usage: tl [loop] <ledger arguments>'
else
  options='--date-width=0 --account-width=30 --payee-width=0 --columns=60 --pager=cat'
  count=59
  while true; do
    if [ $count -ge 60 ]; then
      count=0
      clear
    fi
    cut -d ' ' -f 1-3,5- "$LEDGER_TIMELOG" | ledger -f - $options $@
    if [ $? -eq 0 ]; then
      last=$(tail -1 "$LEDGER_TIMELOG")
      if [ ${last:0:1} = 'i' ]; then
        running="\033[1;32m[RUNNING]\033[0m"
        task=$(echo "$last" | sed -E "s/^. +[^ ]+ +[^ ]+ +[^ ]+ +(.+)  +([^ ]+)$/\2 $(printf "\033[1;34m")(\1)$(printf "\033[0m")/")
        status="$running $task"
      else
        status="\033[1;31m[STOPPED]\033[0m"
      fi
      printf "%-$(tput cols)b\n" "$status"
    fi
    $loop || break
    tput cup 0 0
    let count+=1
    sleep 1
  done
fi
