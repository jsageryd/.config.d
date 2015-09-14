#!/usr/bin/env sh

# Creates or re-uses tmux session called "share", starts up gotty to connect
# to this session, copies GoTTY URL to clipboard.

which -s tmux || (echo tmux not found; exit 1)
which -s gotty || (echo gotty not found; exit 1)
which -s openssl || (echo openssl not found; exit 1)

port=5555
hash=$(head -c16 /dev/urandom | openssl sha1)
user=$(printf $hash | cut -c1-10)
pass=$(printf $hash | cut -c11-20)
default_gateway=$(netstat -nr | awk '/^default.*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/{print $2}')
network=$(echo "$default_gateway" | sed -E 's/\.[0-9]+$//')
ip=$(ifconfig | grep "$network" | awk '{print $2}')
printf "http://$user:$pass@$ip:$port/" | pbcopy

tmux new -A -d -s share
gotty --address 0.0.0.0 --port $port --credential "$user:$pass" --permit-write tmux attach -t share
