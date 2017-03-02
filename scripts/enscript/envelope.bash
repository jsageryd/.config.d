#!/usr/bin/env bash

# 1. Place C5 envelope front-side up, flap to the left
# 2. Pipe the address to this script

# ┌──────────┐
# │╲         │
# │ |        │
# │ │        │
# │ │        │
# │ │        │
# │ |        │
# │╱         │
# └──────────┘

iconv -t iso-8859-1 | enscript -M C5 -B -f Courier@14 -r --margins 350:0:0:300
