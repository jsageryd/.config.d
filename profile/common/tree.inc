# Prints the contents of the specified or current directory as a tree-view.
tree(){
  [ ! -z "$1" ] && p=$1 || p=.
  find "$p" -print | sed -e 's;[^/]*/;|____ ;g;s;____ |; |;g'
}

# Same as above, but only prints directories.
dirtree(){
  [ ! -z "$1" ] && p=$1 || p=.
  find "$p" -type d -print | sed -e 's;[^/]*/;|____ ;g;s;____ |; |;g'
}
