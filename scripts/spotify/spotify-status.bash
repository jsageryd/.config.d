#!/bin/bash

ps aux | grep -v grep | grep -q Spotify.app || exit

state=$(osascript -e 'tell application "Spotify" to player state')
[ "$state" == "playing" ] && state="▶ " || state="❚❚"
artist=$(osascript -e 'tell application "Spotify" to artist of current track')
album=$(osascript -e 'tell application "Spotify" to album of current track')
track=$(osascript -e 'tell application "Spotify" to name of current track')
position=$(
  osascript -e 'tell application "Spotify"
    set pos to player position
    set rPos to (round (pos) rounding down)
  end tell
  return rPos'
)
duration=$(
  osascript -e 'tell application "Spotify"
    set dur to duration of current track / 1000
    set rDur to (round (dur) rounding down)
  end tell
  return rDur'
)

posMM="$(($position/60))"
posSS="$(($position%60))"
durMM="$(($duration/60))"
durSS="$(($duration%60))"

printf "%s - %s [%d:%02d / %d:%02d] %s\n" "$artist" "$track" "$posMM" "$posSS" "$durMM" "$durSS" "$state"
