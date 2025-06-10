#!/bin/sh

key=$(</dev/random head -c 2048 | base64 | tr -d '+/=' | head -c 20)
printf $key | pbcopy
if [ "$COLOUR_SCHEME" = "light" ]; then
  printf 'New key copied: \e[48;5;45m%.3s...\e[0m\n' $key
else
  printf 'New key copied: \e[38;5;45m%.3s...\e[0m\n' $key
fi
