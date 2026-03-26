tt(){
  if [ -z "$1" ]; then
    tmux-tomato -h
  else
    tmux-tomato "$@"
  fi
}
