#!/usr/bin/env bash

# Time-of-day progress bar for the tmux status line. Mirrors the nvim splash
# screen; keep the periods and palette in sync with nvim/plugin/splash.lua

BLOCK='■'
PERIOD_HOURS=3
DAY_PERIODS=6
INACTIVE='#232323'

starts=(5 8 11 14 17 20 23)
bases=('#4e2a3b' '#63451f' '#2a4456' '#334128' '#283e39' '#263247' '#303030')
peaks=('#ff7fb2' '#ffc257' '#5fbfea' '#aeda6f' '#72e0c6' '#76a6ff' '#7d7d7d')

# As many blocks as the client is wide, rounded down to a multiple of
# PERIOD_HOURS so the hour gaps fall on block boundaries. A block is then
# whatever fraction of an hour it has to be. Anything wider would be truncated
# by tmux, cutting off the right-hand end of the bar and so misreporting the
# time.
width=${1:-0}
[[ $width =~ ^[0-9]+$ ]] || width=0
GAPS=$((DAY_PERIODS * PERIOD_HOURS - 1))
BLOCKS_PER_PERIOD=$(((width - GAPS) / DAY_PERIODS / PERIOD_HOURS * PERIOD_HOURS))
((BLOCKS_PER_PERIOD < PERIOD_HOURS)) && BLOCKS_PER_PERIOD=$PERIOD_HOURS
((BLOCKS_PER_PERIOD > 180)) && BLOCKS_PER_PERIOD=180
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

# While the marker sits on the last block of an hour, the rest of that hour is
# lit in the peak colour too, marking the hour about to end. Skipped when a
# block is a whole hour, as every block would then be a last block and the hour
# would stay lit for good.
hour_first=0
hour_last=0
if ((BLOCKS_PER_HOUR > 1)) && ((marker % BLOCKS_PER_HOUR == 0)); then
  hour_first=$((marker - BLOCKS_PER_HOUR + 1))
  hour_last=$marker
fi

out=''
for ((i = 1; i <= DAY_PERIODS; i++)); do
  for ((j = 1; j <= BLOCKS_PER_PERIOD; j++)); do
    if ((i != current)); then
      out+="#[fg=$INACTIVE]$BLOCK"
    elif ((j == marker)); then
      out+="#[fg=${peaks[current-1]},bold]$BLOCK#[nobold]"
    elif ((j >= hour_first && j <= hour_last)); then
      out+="#[fg=${peaks[current-1]}]$BLOCK"
    else
      out+="#[fg=${bases[current-1]}]$BLOCK"
    fi
    if ((j % BLOCKS_PER_HOUR == 0)) && ((i != DAY_PERIODS || j != BLOCKS_PER_PERIOD)); then
      out+=' '
    fi
  done
done

printf '%s' "$out"
