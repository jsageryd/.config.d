#!/usr/bin/env bash

if which -s reattach-to-user-namespace; then
  reattach-to-user-namespace "$@"
else
  exec "$@"
fi
