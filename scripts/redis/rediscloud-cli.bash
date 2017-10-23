#!/usr/bin/env bash

# Takes a Heroku application name and runs redis-cli with password, host,
# password extracted from the REDISCLOUD_URL env variable in the application
# settings.

if [ -z $1 ]; then
  >&2 echo "Usage: rediscloud-cli <heroku application name>"
  exit 1
fi

url=$(heroku config:get REDISCLOUD_URL --app $1)

password=$(sed 's#.*:\(.*\)@.*#\1#' <<< $url)
host=$(sed 's#.*@\(.*\):.*#\1#' <<< $url)
port=$(sed 's#.*:\(.*\).*#\1#' <<< $url)

redis-cli -h $host -p $port -a $password
