#!/usr/bin/env sh

string="$(pbpaste)"
len=$(printf "$string" | wc -c | tr -d ' ')
echo "$string"
echo "Length $len"
