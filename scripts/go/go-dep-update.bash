#!/usr/bin/env bash

isGitRepo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
  return $?
}

repoIsDirty() {
  [ ! -z "$(git status --porcelain)" ]
  return $?
}

if ! isGitRepo; then
  echo "Not a repo"
  exit 1
fi

if repoIsDirty; then
  echo "Repo is dirty"
  exit 1
fi

if ! which -s dep; then
  cmd="go get github.com/golang/dep/cmd/dep"
  echo "dep not found."
  read -p "$cmd [y/n]? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    $cmd
  else
    exit 0
  fi
fi

output="$(dep status && dep ensure && dep ensure -update && echo && dep status)"

if ! repoIsDirty; then
  echo "No change"
  exit 0
fi

git add .
git commit -m "Update vendored dependencies

$ dep status && dep ensure && dep ensure -update && echo && dep status
$output
"
