#!/usr/bin/env bash

unsorted=$(ledger register --format='%(format_date(date, "%Y-%m-%d"))\n' | uniq)
if diff <(echo "$unsorted") <(echo "$unsorted" | sort); then
  echo -e "\033[1;32mTransactions are in chronological order.\033[0m"
  exit 0
else
  echo -e "\n\033[1;31mTransactions are not in chronological order.\033[0m"
  exit 1
fi
