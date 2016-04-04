#!/usr/bin/env bash

set -e

git checkout --detach
git merge "$@"
