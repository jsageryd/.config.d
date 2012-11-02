# Time logger

# Johan S; November 2010

# Source this file in bash.
# source timelogger.conf

# Store time log files in TIMELOGDIR
TIMELOGDIR=~/Documents/timelog

# Don't log less than MINIMUM_LOG_TIME seconds
MINIMUM_LOG_TIME=60

# Editor
EDITOR=vi

log(){
  command=$1
  [ -z "$command" ] && command=help
  shift
  case "$command" in
        init) _log_cmd_init $@ ;;
     destroy) _log_cmd_destroy $@ ;;
       start) _log_cmd_start $@ ;;
     unstart) _log_cmd_unstart ;;
        stop) _log_cmd_stop ;;
      manual) _log_cmd_manual $@ ;;
      status) _log_cmd_status $@ ;;
        list) _log_cmd_list ;;
         raw) _log_cmd_raw $@ ;;
        show) _log_cmd_show $@ ;;
        last) _log_cmd_last $@ ;;
        help) _log_cmd_help ;;
    settings) _log_cmd_settings ;;
        edit) _log_cmd_edit $@ ;;
           *) _log_cmd_invalid ;;
  esac
}

_log_cmd_init(){
  _log_ne $1 || return 1
  logfile=$(_log_file $1)
  mkdir -p $TIMELOGDIR
  touch $logfile && echo -e "Log created: $logfile" || echo -e "Unable to create log: $logfile"
}

_log_cmd_destroy(){
  _log_ne $1 || return 1
  logfile=$(_log_file $1)
  [ -e "$logfile" ] && rm -i $logfile || echo "No such log file. Type 'log list' for a list of available logs."
}

_log_cmd_start(){
  _log_ne $1 || return 1
  _log_ne $2 || return 1
  if ! _log_exists $1; then
    echo "Log does not exist. Create it by typing 'log init $1'."
    return 1
  fi
  _log_current > /dev/null
  if [ $? -eq 0 ]; then
    _log_cmd_stop
    seconds=$(($(_log_seconds)+1))
  else
    seconds=$(_log_seconds)
  fi
  log=$1
  logfile=$(_log_file $1)
  shift
  comment=$@
  echo -e "$seconds\tSTART\t$log\t${comment[*]}" >> $logfile
  _log_cmd_last $log
}

_log_cmd_unstart(){
  log=$(_log_current)
  if [ $? -eq 0 ]; then
    last=$(_log_cmd_last $log)
    logfile=$(_log_file $log)
    wcl=$(wc -l $logfile)
    linecount=$(echo ${wcl%%/ } | cut -f 1 -d ' ')
    if [ $linecount -eq 1 ]; then
      cat /dev/null > $logfile
    else
      tmp=$(head -$((linecount - 1)) $logfile)
      echo "$tmp" > $logfile
    fi
    echo "${last/RUNNING/CANCELLED}"
  else
    echo "No timer running."
  fi
}

_log_cmd_stop(){
  seconds=$(_log_seconds)
  log=$(_log_current)
  if [ $? -eq 0 ]; then
    starttime=$(_log_cmd_raw $log | tail -1 | cut -f 1)
    delta=$((seconds - starttime))
    if [ $delta -le $MINIMUM_LOG_TIME ]; then
      echo "Logged time less than minimum log time."
      _log_cmd_unstart
    else
      logfile=$(_log_file $log)
      echo -e "$seconds\tSTOP\t$log" >> $logfile
      echo "$(_log_cmd_last $log) [STOPPED]"
    fi
  else
    echo "No timer running."
  fi
}

_log_cmd_manual(){
  _log_ne $1 || return 1
  log=$1
  if ! _log_exists $log; then
    echo "Log does not exist. Create it by typing 'log init $log'."
    return 1
  fi
  if _log_running $log; then
    echo "[$log] The log is currently running. Stop or unstart it before manual entry."
    return 1
  fi
  logfile=$(_log_file $log)

  false
  while [ $? -ne 0 ]; do
    echo -n "Start date (yyyy-mm-dd)? "
    startdate=$(_log_readdatetime "%Y-%m-%d")
  done

  false
  while [ $? -ne 0 ]; do
    echo -n "Start time (hh:mm)? "
    starttime=$(_log_readdatetime "%H:%M")
  done
  startseconds=$(date -jf "%Y-%m-%d %H:%M:%S" "${startdate} ${starttime}:00" "+%s")

  false
  while [ $? -ne 0 ]; do
    false
    while [ $? -ne 0 ]; do
      echo -n "Stop time (hh:mm)? "
      stoptime=$(_log_readdatetime "%H:%M")
    done

    stopseconds=$(date -jf "%Y-%m-%d %H:%M:%S" "${startdate} ${stoptime}:00" "+%s")
    if [ $stopseconds -lt $startseconds ]; then
      let stopseconds+=86400
    fi
    if [ $(($stopseconds - $startseconds)) -le $MINIMUM_LOG_TIME ]; then
      echo "Entered time less than minimum log time."
      false
    fi
  done

  echo -n "Comment? "
  read comment

  echo -e "$startseconds\tSTART\t$log\t$comment" >> $logfile
  echo -e "$stopseconds\tSTOP\t$log" >> $logfile

  _log_cmd_last $log

  _log_sort $log
}

_log_cmd_status(){
  for log in $(_log_cmd_list); do
    _log_cmd_last $log || echo "[$log] Log empty."
  done
}

_log_cmd_list(){
  ls "$TIMELOGDIR"
}

_log_cmd_raw(){
  _log_ne $1 || return 1
  if ! _log_exists $1; then
    echo "Log does not exist: $1"
    return 1
  else
    cat $(_log_file $1)
    return 0
  fi
}

_log_cmd_show(){
  _log_ne $1 || return 1
  log=$1
  logfile=$(_log_file $log)
  if ! _log_exists $log; then
    echo "Log does not exist: $log"
    return 1
  fi
  sum=0
  lines=0
  grep=false
  if [ ! -z "$2" ]; then
    grep=true
    shift
    grepstrs=$@
    grepstr=${grepstrs[*]}
  fi
  started=false
  while read line; do
    let lines+=1
    if echo "$line" | cut -f 2 | grep -qi START; then
      started=true
      starttime=$(echo "$line" | cut -f 1)
      startcomment=$(echo "$line" | cut -f 4-)
    elif echo "$line" | cut -f 2 | grep -qi STOP; then
      ! $started && continue;
      stoptime=$(echo "$line" | cut -f 1)
      delta=$((stoptime - starttime))
      let sum+=$delta
      fdelta=$(_log_format_delta $delta)
      fstarttime=$(date -jr $starttime "+%Y-%m-%d %H:%M")
      fstoptime=$(date -jr $stoptime "+%H:%M")
      if $grep; then
        if echo "$startcomment" | grep -qi "$grepstr"; then
          echo -e "[$log] $fstarttime - $fstoptime ($fdelta)\t$startcomment"
        else
          let sum-=$delta
        fi
      else
        echo -e "[$log] $fstarttime - $fstoptime ($fdelta)\t$startcomment"
      fi
    fi
  done < $logfile
  if _log_running $log && [ $lines -gt 0 ]; then
    now=$(_log_seconds)
    delta=$((now - starttime))
    let sum+=$delta
    fdelta=$(_log_format_delta $delta)
    fstarttime=$(date -jr $starttime "+%Y-%m-%d %H:%M")
    fnow=$(date -jr $now "+%H:%M")
    if $grep; then
      if echo "$startcomment" | grep -qi "$grepstr"; then
        echo -e "[$log] $fstarttime - $fnow ($fdelta)\t$startcomment [RUNNING]"
      else
        let sum-=$delta
      fi
    else
      echo -e "[$log] $fstarttime - $fnow ($fdelta)\t$startcomment [RUNNING]"
    fi
  fi
  if [ $lines -eq 0 ]; then
    if $grep; then
      echo "[$log] Empty result."
    else
      echo "[$log] Log empty."
    fi
    return 1
  else
    echo "--------------------"
    fsum=$(_log_format_delta $sum)
    echo "Total: $fsum"
    return 0
  fi
}

_log_cmd_last(){
  _log_ne $1 || return 1
  show=$(_log_cmd_show $1)
  if [ $? -eq 0 ]; then
    last=$(echo "$show" | tail -3 | head -1)
    echo $last
    return 0
  else
    return 1
  fi
}

_log_cmd_help(){
  echo
  echo -e " log \033[34minit\033[0m <log>              creates a new log for <log>"
  echo -e " log \033[34mdestroy\033[0m <log>           destroys the log for <log>"
  echo -e " log \033[34mstart\033[0m <log> <comment>   starts the timer for <log>"
  echo -e " log \033[34munstart\033[0m                 stops any running timer without recording the time"
  echo -e " log \033[34mstop\033[0m                    stops any running timer and records the time"
  echo -e " log \033[34mmanual\033[0m                  manual log entry"
  echo -e " log \033[34mstatus\033[0m                  shows status for all timers"
  echo -e " log \033[34mlist\033[0m                    lists all log files"
  echo -e " log \033[34mraw\033[0m <log>               shows the raw log entries for <log>"
  echo -e " log \033[34mshow\033[0m <log> [grepstr]    shows the log entries for <log>, optionally filtered by [grepstr]"
  echo -e " log \033[34mlast\033[0m <log>              shows the last log entry for <log>"
  echo -e " log \033[34mhelp\033[0m                    shows this information"
  echo -e " log \033[34msettings\033[0m                show settings"
  echo -e " log \033[34medit\033[0m <log>              opens <log> for manual editing"
  echo
}

_log_cmd_settings(){
  echo
  echo -e "     Log dir:\t$TIMELOGDIR"
  echo -e "Min log time:\t$MINIMUM_LOG_TIME seconds"
  echo
}

_log_cmd_edit(){
  _log_ne $1 || return 1
  logfile=$(_log_file $1)
  $EDITOR "$logfile"
}

_log_cmd_invalid(){
  echo "Invalid syntax. Type 'log help' for info."
}

# Verifies that $1 is not empty. Displays error message if empty.
# Returns zero if not empty, otherwise non-zero.
_log_ne(){
  if [ ! -z "$1" ]; then
    return 0
  else
    _log_cmd_invalid
    return 1
  fi
}

# Echoes path to specified log
_log_file(){
  _log_ne $1 || return 1
  echo "${TIMELOGDIR%/}/$1"
}

# Checks if specified log exists.
# Returns zero if it does, otherwise non-zero.
_log_exists(){
  _log_ne $1 || return 1
  [ -f $(_log_file $1) ] && return 0 || return 1
}

# Checks if specified log is running.
# Returns zero if it is, otherwise non-zero.
_log_running(){
  _log_ne $1 || return 1
  _log_exists $1 || return 1
  logfile=$(_log_file $1)
  tail -1 $logfile | cut -f 2 | grep -qi START
}

# Echoes current time in seconds
_log_seconds(){
  echo $(date -j "+%s")
}

# Formats seconds into proper time format
_log_format_delta(){
  _log_ne $1 || return 1
  seconds=$1
  hours=$((seconds / 3600))
  seconds=$((seconds % 3600))
  minutes=$((seconds / 60))
  padding='00'
  echo "${hours}h ${padding:${#minutes}}${minutes}m"
}

# Echoes currently running log.
# Returns zero if there is a running log, otherwise non-zero.
_log_current(){
  for log in $(_log_cmd_list); do
    if _log_running $log; then
      echo $log
      return 0
    fi
  done
  return 1
}

# Reads datetime from cmdline and verifies its format.
# Echoes the read value.
# Returns zero if the value is properly formatted, otherwise non-zero.
# Argument $1 is expected date format (ex. %Y-%m-%d)
_log_readdatetime(){
  read input
  converted=$(date -jf "$1" "$input" "+$1" 2> /dev/null)
  if [ ! -z "$converted" ] && [ "$input" = "$converted" ]; then
    echo $converted
    return 0
  else
    return 1
  fi
}

# Sorts the specified log so that entries are in chronological order
_log_sort(){
  _log_ne $1 || return 1
  log=$1
  _log_exists $log || return 1
  if _log_isvalid $log; then
    logfile=$(_log_file $log)
    tmp=$(sort -k 1 $logfile)
    echo "$tmp" > $logfile
  else
    echo -e "[$log] There are conflicting entries in the log. Log entries will not be sorted."
    return 1
  fi
  return 0
}

# Checks if the specified log file is valid through a simple check
# temporarily sorting the log entries in chronological order and
# and checking if there are two START entries or two STOP entries
# one immediately following the other.
# In this case the return value is non-zero, otherwise (if the log
# seems to have no conflicts) zero.
_log_isvalid(){
  _log_ne $1 || return 1
  logfile=$(_log_file $1)
  tmp=$(sort -k 1 $logfile)
  unset last
  IFS=$'\n'
  for line in $(echo "$tmp"); do
    current=$(echo "$line" | cut -f 2);
    if [ "$current" = "$last" ]; then
      return 1
    fi
    last="$current"
  done
  unset IFS
  return 0
}
