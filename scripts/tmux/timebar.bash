#!/usr/bin/env bash

# Time-of-day progress bar for the tmux status line. Mirrors the nvim splash
# screen; keep the periods and palette in sync with nvim/plugin/splash.lua

BLOCK='■'
PERIOD_HOURS=3
DAY_PERIODS=5
INACTIVE='#252525'

starts=(5 8 11 14 17 20)
bases=('#4a2838' '#4a4238' '#2e3a4a' '#323a28' '#2a3048' '#333333')
peaks=('#b05878' '#b09050' '#5080a0' '#709048' '#5878c0' '#707070')

# Finest resolution that fits the client: 5, 10, 15, 30 or 60 minutes a block.
# Anything wider would be truncated by tmux, cutting off the right-hand end of
# the bar and so misreporting the time.
width=${1:-0}
[[ $width =~ ^[0-9]+$ ]] || width=0
BLOCKS_PER_PERIOD=6
for candidate in 36 18 12 6 3; do
  if ((candidate * DAY_PERIODS <= width)); then
    BLOCKS_PER_PERIOD=$candidate
    break
  fi
done

read -r hour minute < <(date '+%H %M')
hour=$((10#$hour))
minute=$((10#$minute))

current=${#starts[@]}
for ((i = ${#starts[@]}; i >= 1; i--)); do
  if ((hour >= starts[i-1])); then
    current=$i
    break
  fi
done

start=${starts[current-1]}
elapsed=$(((hour - start) * 60 + minute))
marker=$((elapsed * BLOCKS_PER_PERIOD / (PERIOD_HOURS * 60) + 1))

out=''
for ((i = 1; i <= DAY_PERIODS; i++)); do
  for ((j = 1; j <= BLOCKS_PER_PERIOD; j++)); do
    if ((i != current)); then
      out+="#[fg=$INACTIVE]$BLOCK"
    elif ((j == marker)); then
      out+="#[fg=${peaks[current-1]},bold]$BLOCK#[nobold]"
    else
      out+="#[fg=${bases[current-1]}]$BLOCK"
    fi
  done
done

printf '%s' "$out"
