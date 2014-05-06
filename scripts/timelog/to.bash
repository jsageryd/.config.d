#!/usr/bin/env bash

# Time out

if [ -z "$LEDGER_TIMELOG" ]; then
  echo '$LEDGER_TIMELOG not set. Set it to the path of the timelog file.' >&2
  exit 1
fi

if [ ! -e "$LEDGER_TIMELOG" ]; then
  echo "Timer not running."
  exit 1
fi

last=$(tail -1 "$LEDGER_TIMELOG")
if [ "${last:0:1}" = 'o' ]; then
  echo "Timer not running."
  exit 1
else
  time="$(date -j +'%Y-%m-%d %H:%M:%S %z')"
  echo "o $time" >> "$LEDGER_TIMELOG"
  ts
fi
