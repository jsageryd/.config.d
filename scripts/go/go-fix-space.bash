#!/bin/bash

# Replace tabs with double spaces in all Go files recursively and run gofmt
find . -name "*.go" -type f -not -path "./vendor/*" | while read -r file; do
  sed -i '' 's/\t/  /g' "$file"
  gofmt -w "$file"
done
