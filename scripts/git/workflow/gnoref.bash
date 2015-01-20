#!/usr/bin/env bash

# Finds commits (not counting merges) that do not contain an issue reference,
# specifically /^refs( #[0-9]{4,5})+$/, in the current branch since it was
# branched from origin/master or specified base, specifically base..HEAD. Prints
# list of offending commits and exits 0 if such commits exist, otherwise 1.

if [ ! -z $1 ]; then
  base=$1
else
  base=origin/master
fi
unreferenced=$(comm -23 <(git rev-list --no-merges $base..HEAD | sort) \
  <(git rev-list --no-merges -E --grep '^refs( #[0-9]{4,5})+$' $base..HEAD | sort))
if [ -z "$unreferenced" ]; then
  exit 1
else
  count=$(echo "$unreferenced" | wc -l | tr -d ' ')
  git log --abbrev-commit --abbrev=10 --no-walk $unreferenced
  if [[ $count -eq 1 ]]; then
    printf "\n\033[1;31mThis commit lacks proper issue reference.\033[0m\n"
  else
    printf "\n\033[1;31mThese $count commits lack proper issue references.\033[0m\n"
  fi
  exit 0
fi
