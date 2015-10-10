#!/usr/bin/env sh

string="$(pbpaste)"
len=$(echo "$string" | wc -c | tr -d ' ')
echo "$string"
echo "Length $len"
