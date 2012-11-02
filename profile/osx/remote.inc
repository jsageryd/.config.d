wake(){
  if [ ! -z $1 ]; then
    ssh $1 osascript -e \'tell application \"Finder\" to activate\' -e \'tell application \"System Events\" to key code 124\';
  fi
}

stroke(){
  if [ ! -z $1 ]; then
    if [ ! -z $2 ]; then
      if [ ! -z $3 ]; then
        ssh $1 osascript -e \'tell application \"System Events\" to keystroke \"$3\" using $2 down\';
      else
        ssh $1 osascript -e \'tell application \"System Events\" to keystroke \"$2\"\';
      fi
    fi
  fi
}

code(){
  if [ ! -z $1 ]; then
    if [ ! -z $2 ]; then
      if [ ! -z $3 ]; then
        ssh $1 osascript -e \'tell application \"System Events\" to key code $3 using $2 down\';
      else
        ssh $1 osascript -e \'tell application \"System Events\" to key code $2\';
      fi
    fi
  fi
}

click(){
  if [ ! -z $1 ]; then
    ssh $1 osascript -e \'tell application \"System Events\" to click\';
  fi
}
