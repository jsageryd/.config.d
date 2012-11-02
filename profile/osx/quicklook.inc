p(){
  killall qlmanage > /dev/null 2>&1
  if [ "$1" ]; then
    qlmanage -p "$1" > /dev/null 2>&1 &
  fi
}
