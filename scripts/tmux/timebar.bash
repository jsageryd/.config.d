#!/usr/bin/env bash

# Time-of-day progress bar for the tmux status line. Mirrors the nvim splash
# screen; keep the periods and palette in sync with nvim/plugin/splash.lua

BLOCK='■'
PERIOD_HOURS=3
DAY_PERIODS=6
INACTIVE='#2f2f2f'

starts=(5 8 11 14 17 20 23)
bases=('#68384f' '#6c5533' '#385a73' '#445635' '#35534c' '#33425f' '#404040')
peaks=('#ff93b8' '#f8c96b' '#5fbfea' '#9dca65' '#65d3b9' '#6fa2ef' '#7d7d7d')

# Finest resolution that fits the client: 5, 6, 10, 12, 15, 20, 30 or 60 minutes
# a block. Each candidate divides the period into whole minutes and is a
# multiple of PERIOD_HOURS, so the hour gaps fall on block boundaries. Anything
# wider would be truncated by tmux, cutting off the right-hand end of the bar
# and so misreporting the time.
width=${1:-0}
[[ $width =~ ^[0-9]+$ ]] || width=0
BLOCKS_PER_PERIOD=6
GAPS=$((DAY_PERIODS * PERIOD_HOURS - 1))
for candidate in 36 30 18 15 12 9 6 3; do
  if ((candidate * DAY_PERIODS + GAPS <= width)); then
    BLOCKS_PER_PERIOD=$candidate
    break
  fi
done
BLOCKS_PER_HOUR=$((BLOCKS_PER_PERIOD / PERIOD_HOURS))

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
    if ((j % BLOCKS_PER_HOUR == 0)) && ((i != DAY_PERIODS || j != BLOCKS_PER_PERIOD)); then
      out+=' '
    fi
  done
done

printf '%s' "$out"
