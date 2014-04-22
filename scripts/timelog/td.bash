#!/usr/bin/env bash

# Time log diff since last commit

if [ -z "$LEDGER_TIMELOG" ]; then
  echo '$LEDGER_TIMELOG not set. Set it to the path of the timelog file.' >&2
  exit 1
fi

pushd $(dirname "$LEDGER_TIMELOG") && \
git diff && \
popd
