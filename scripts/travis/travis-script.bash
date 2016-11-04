#!/usr/bin/env bash

if [ ! -f ".travis.yml" ]; then
  echo ".travis.yml missing"
  exit 1
fi

if ! which -s yaml2json; then
  cmd="go get github.com/buildkite/yaml2json"
  echo "yaml2json not found."
  read -p "$cmd [y/n]? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    $cmd
  else
    exit 0
  fi
fi

if ! which -s jq; then
  cmd="brew install jq"
  echo "jq not found."
  read -p "$cmd [y/n]? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    $cmd
  else
    exit 0
  fi
fi

yaml2json .travis.yml | jq -r ".script|select (.!=null)|.[]" | sh
