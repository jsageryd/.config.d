#!/usr/bin/env bash

# Takes an URL like redis://rediscloud:<password>@<host>:<port>
# and runs redis-cli with extracted password, host, password.

if [ -z $1 ]; then
  >&2 echo "Usage: rediscloud-cli redis://rediscloud:<password>@<host>:<port>"
  exit 1
fi

password=$(sed 's#.*:\(.*\)@.*#\1#' <<< $1)
host=$(sed 's#.*@\(.*\):.*#\1#' <<< $1)
port=$(sed 's#.*:\(.*\).*#\1#' <<< $1)

redis-cli -h $host -p $port -a $password
