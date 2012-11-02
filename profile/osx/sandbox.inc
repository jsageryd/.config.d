alias sb=sandbox
sandbox(){
  if [ ! -z "$1" ]; then
    sandbox-exec -p '(version 1) (debug deny) (allow default) (deny network* file-write*)' "$1"
  else
    echo "";
    echo "Executes a program or script in a sandbox that prevents network access and writing to disk.";
    echo "Denied actions are logged to syslog.";
    echo "";
    echo "sandbox <program>";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "sandbox /Applications/TextEdit.app/Contents/MacOS/TextEdit";
    echo -e " Starts TextEdit in a sandbox";
    echo "";
  fi
}

alias sbn=sandboxnetwork
sandboxnetwork(){
  if [ ! -z "$1" ]; then
    sandbox-exec -p '(version 1) (debug deny) (allow default) (deny network*)' "$1"
  else
    echo "";
    echo "Executes a program or script in a sandbox that prevents network access.";
    echo "Denied actions are logged to syslog.";
    echo "";
    echo "sandboxnetwork <program>";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "sandboxnetwork /Applications/TextEdit.app/Contents/MacOS/TextEdit";
    echo -e " Starts TextEdit in a sandbox";
    echo "";
  fi
}

alias sbw=sandboxwriting
sandboxwriting(){
  if [ ! -z "$1" ]; then
    sandbox-exec -p '(version 1) (debug deny) (allow default) (deny file-write*)' "$1"
  else
    echo "";
    echo "Executes a program or script in a sandbox that prevents writing to disk.";
    echo "Denied actions are logged to syslog.";
    echo "";
    echo "sandboxwriting <program>";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "sandboxwriting /Applications/TextEdit.app/Contents/MacOS/TextEdit";
    echo -e " Starts TextEdit in a sandbox";
    echo "";
  fi
}

# For logging file system writes to file
trace(){
  if [ ! -z "$1" ] && [ ! -z "$2" ]; then
    sandbox-exec -p "(version 1) (allow default) (deny file-write*) (trace \"$2\")" "$1"
  else
    echo "";
    echo "Executes a program or script in a sandbox that logs all file system writes. ";
    echo "";
    echo "trace <program> <logfile>";
    echo "";
    echo -en "\033[1m Ex.:\t\033[0m";
    echo "trace /Applications/TextEdit.app/Contents/MacOS/TextEdit ~/textedit_trace.sb";
    echo -e " Starts TextEdit and logs its file writes to ~/textedit_trace.sb";
    echo "";
  fi
}
