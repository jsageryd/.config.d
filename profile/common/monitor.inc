# File monitor
monitor_file(){
  if [ ! -z $1 ]; then
    while [ 1 ];
    do
      cat $1;
      sleep 5;
      clear;
    done
  fi
}

# Directory monitor
alias monitor_dir="while [ 1 ]; do clear ; l; sleep 5; done"
