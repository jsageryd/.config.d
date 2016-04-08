#!/usr/bin/env bash

# Time log update (pull && commit && push)

if [ -z "$LEDGER_TIMELOG" ]; then
  echo '$LEDGER_TIMELOG not set. Set it to the path of the timelog file.' >&2
  exit 1
fi

echo 'Fetching...'
git --git-dir="$(dirname $LEDGER_TIMELOG)/.git" fetch
echo 'done.'

last=$(tail -1 "$LEDGER_TIMELOG")
if [ "${last:0:1}" = 'i' ]; then
  echo 'Log seems to be running. Clock out before update.' >&2
  exit 1
fi

cd $(dirname "$LEDGER_TIMELOG") && \
git merge @{u} --ff-only && \
git add $(basename "$LEDGER_TIMELOG") && \
git commit -m "Update $(date +'%Y-%m-%d %H:%M')"
git push
