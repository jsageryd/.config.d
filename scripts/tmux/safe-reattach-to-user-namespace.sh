#!/usr/bin/env bash

if which reattach-to-user-namespace > /dev/null 2>&1; then
  reattach-to-user-namespace "$@"
else
  exec "$@"
fi
