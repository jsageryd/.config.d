#!/usr/bin/env bash

# Time log edit

if [ -z "$LEDGER_TIMELOG" ]; then
  echo '$LEDGER_TIMELOG not set. Set it to the path of the timelog file.' >&2
  exit 1
fi

$EDITOR "$LEDGER_TIMELOG"
