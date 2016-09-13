#!/usr/bin/env bash

if [ -f ".travis.yml" ]; then
  yaml2json .travis.yml | jq -r ".script|select (.!=null)|.[]" | sh
else
  echo ".travis.yml missing"
fi
