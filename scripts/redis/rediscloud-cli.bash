#!/usr/bin/env bash

# Takes a Heroku application name and runs redis-cli with password, host,
# password extracted from the REDISCLOUD_URL env variable in the application
# settings.

if [ -z $1 ]; then
  >&2 echo "Usage: rediscloud-cli <heroku application name>"
  exit 1
fi

app=$1

if echo $app | grep -q -- '-prod'; then
  prefix=${app%-prod}
  echo -en "Connecting to $prefix\033[1;31m-prod\033[0m. Enter \033[1;31mDANGER ZONE\033[0m [y/n]? "
  read -n 1 -r
  echo
  if ! [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Abort, abort!"
    exit 0
  fi
  echo -en "Type the name of the app just in case: "
  read
  if [ "$REPLY" != $app ]; then
    echo "Not quite right. Try again with the right name."
    exit 1
  fi
fi

url=$(heroku config:get REDISCLOUD_URL --app $app)

password=$(sed 's/.*:\(.*\)@.*/\1/' <<< $url)
host=$(sed 's/.*@\(.*\):.*/\1/' <<< $url)
port=$(sed 's/.*:\(.*\).*/\1/' <<< $url)

redis-cli -h $host -p $port -a $password
