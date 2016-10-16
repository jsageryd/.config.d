#!/usr/bin/env bash

# Time in

if [ -z "$LEDGER_TIMELOG" ]; then
  echo '$LEDGER_TIMELOG not set. Set it to the path of the timelog file.' >&2
  exit 1
fi

payee=$1
shift
if [ $# -eq 0 ]; then
  echo 'Usage: ti <payee> <account>'
  echo 'Example: ti my_client Implement feature X'
else
  unix_time="$(date +%s)"
  rounded_time="$((($unix_time + 900) - ($unix_time + 900) % 1800))"
  time="$(date -j -f '%s' $rounded_time +'%Y-%m-%d %H:%M:%S %z')"
  if [ -e "$LEDGER_TIMELOG" ]; then
    last=$(tail -1 "$LEDGER_TIMELOG")
    if [ "${last:0:1}" = 'i' ]; then
      to
      time=$(tail -1 "$LEDGER_TIMELOG" | sed -E 's/^. +([^ ]+ +[^ ]+ +[^ ]+).*$/\1/')
    fi
  fi
  account="$*"
  echo "i $time $account  $payee" >> "$LEDGER_TIMELOG"
  echo -e "\033[1;32m[START]\033[0m $payee \033[1;34m($account)\033[0m $time"
fi
