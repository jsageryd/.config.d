#!/usr/bin/env bash

# Shows branches with descriptions
# The first word in the description is specially highlighted:
# - ice means branch is on ice, halted for the time being
# - jrf means just for reference
# - wip means work in progress

if [ "$1" = '--sort' -o "$1" = '-s' ]; then
  branches_with_time=$(git for-each-ref --format='%(committerdate:raw):%(refname:short):%(committerdate:relative)' refs/heads/ | sort -rn | sed -E 's/^[^:]+://')
elif [ ! -z "$1" ]; then
  echo "Invalid argument '$1'"
  echo 'Usage:'
  echo '  --sort (-s) sort branches by last commit time'
  return
else
  branches_with_time=$(git for-each-ref --format='%(refname:short):%(committerdate:relative)' refs/heads/)
fi
activebranch=$(git rev-parse --abbrev-ref HEAD)
descriptions=$(git config --get-regexp 'branch.*description' | tr -s '\n' | sed 's/branch.\(.*\).description \(.*\)/\1:\2/')
color_branch_current="$(git config --get-color color.branch.current green)"
color_branch_local="$(git config --get-color color.branch.local normal)"
echo "$branches_with_time" | while read branch_with_time; do
  branch=${branch_with_time%%:*}
  modified_at=${branch_with_time#*:}
  desc_kv=$(echo "$descriptions" | grep "^$branch:")
  desc="${desc_kv#*:} "
  desc_head=${desc%% *}
  desc_tail=${desc#* }
  desc_tail=${desc_tail% }
  if [ $branch = $activebranch ]; then
    branch="* $color_branch_current$branch\033[0m"
  else
    branch="  $color_branch_local$branch\033[0m"
  fi
  case $desc_head in
    '') ;;
    'ice') desc_head=" \033[0;34m$desc_head\033[0m" ;;
    'jfr') desc_head=" \033[1;33m$desc_head\033[0m" ;;
    'wip') desc_head=" \033[1;31m$desc_head\033[0m" ;;
    *)     desc_head=" \033[0;36m$desc_head\033[0m"
  esac
  [ ! -z "$desc_tail" ] && desc_head="$desc_head "
  echo -e "$branch$desc_head\033[0;36m$desc_tail\033[0m \033[0;37m[$modified_at]\033[0m"
done
